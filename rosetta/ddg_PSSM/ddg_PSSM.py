"""
reqirements:
1. pyrosetta
2. pandas
3. seaborn
4. matplotlib
5. Biopython

This a script for 1 chains protein, to mutate each residue to all 20 amino acids and calculate the ddg value.


"""

#!pip install pyrosettacolabsetup
#import pyrosettacolabsetup; pyrosettacolabsetup.install_pyrosetta()
import pyrosetta
import logging
logging.basicConfig(level=logging.INFO)
import pandas
import seaborn
import matplotlib
import Bio.SeqUtils
import Bio.Data.IUPACData as IUPACData
import pyrosetta
import pyrosetta.distributed.io as io
import pyrosetta.distributed.packed_pose as packed_pose
import pyrosetta.distributed.tasks.rosetta_scripts as rosetta_scripts
import pyrosetta.distributed.tasks.score as score
import os,sys,platform
from typing import List

def mutate_residue(input_pose, res_index, new_aa, res_label = None):
    import pyrosetta.rosetta.core.pose as pose

    work_pose = packed_pose.to_pose(input_pose)

    # Annotate structure with reslabel, for use in downstream protocol
    # Add parameters as score, for use in downstream analysis
    if res_label:
        work_pose.pdb_info().add_reslabel(res_index, res_label)
        pose.setPoseExtraScore(work_pose, "mutation_index", res_index)
        pose.setPoseExtraScore(work_pose, "mutation_aa", new_aa)

    if len(new_aa) == 1:
        new_aa = str.upper(Bio.SeqUtils.seq3(new_aa))
    assert new_aa in map(str.upper, IUPACData.protein_letters_3to1)

    protocol = """
    <ROSETTASCRIPTS>
    <MOVERS>
      <MutateResidue name="mutate" new_res="%(new_aa)s" target="%(res_index)i" />
     </MOVERS>
    <PROTOCOLS>
      <Add mover_name="mutate"/>
    </PROTOCOLS>
    </ROSETTASCRIPTS>
    """ % locals()

    return rosetta_scripts.SingleoutputRosettaScriptsTask(protocol)(work_pose)

def main(data_pdb: str, num_processors: int, selected_aa: List[int]):
    pyrosetta.init()
    #platform.python_version()
    ## Create test pose, initialize rosetta and pack
    input_protocol = """
    <ROSETTASCRIPTS>
      <TASKOPERATIONS>
        <RestrictToRepacking name="only_pack"/>
      </TASKOPERATIONS>

      <MOVERS>
        <PackRotamersMover name="pack" task_operations="only_pack" />
      </MOVERS>

      <PROTOCOLS>
        <Add mover="pack"/>
      </PROTOCOLS>
    </ROSETTASCRIPTS>
    """
    input_relax = rosetta_scripts.SingleoutputRosettaScriptsTask(input_protocol)
    # Syntax check via setup
    input_relax.setup()


    # Use the provided PDB file path
    #data_pdb = args.pdb
    #num_processors = os.cpu_count()


    raw_input_pose = score.ScorePoseTask()(io.pose_from_file(data_pdb))
    input_pose = input_relax(raw_input_pose)
    #selected_aa = [2,3,5,6,8,9,11,12,15,17]
    #selected_aa = [2]
    #selected_aa = range(1, len(packed_pose.to_pose(input_pose).residues) + 1)
    #selected_aa = range(1, 1+18)

    ## Perform exhaustive point mutation and pack



    refine = """
    <ROSETTASCRIPTS>
      <SCOREFXNS>
        <ScoreFunction name="ref15" weights="ref2015"/>
      </SCOREFXNS>
      <RESIDUE_SELECTORS>
        <ResiduePDBInfoHasLabel name="mutation" property="mutation" />
        <Not name="not_neighbor">
          <Neighborhood selector="mutation" distance="12.0" />
        </Not>
      </RESIDUE_SELECTORS>
      <TASKOPERATIONS>
        <RestrictToRepacking name="only_pack"/>
        <OperateOnResidueSubset name="only_repack_neighbors" selector="not_neighbor">
          <PreventRepackingRLT/>
        </OperateOnResidueSubset>
      </TASKOPERATIONS>
      <MOVERS>
        <PackRotamersMover name="pack_area" task_operations="only_pack,only_repack_neighbors" />
        <FastRelax name="relax" scorefxn="ref15" repeats="5"/>
      </MOVERS>
      <PROTOCOLS>
        <Add mover="pack_area"/>
        Add mover="relax"/
      </PROTOCOLS>
    </ROSETTASCRIPTS>
    """
    #refine_mutation = rosetta_scripts.SingleoutputRosettaScriptsTask(refine)
    # Mutation and pack
    ## Job distribution via `multiprocessing`
    from multiprocessing import Pool
    import itertools
    import argparse
    # Add more logging to understand where the error occurs
    logging.info("Starting refinement process")

    try:
        refine_mutation = rosetta_scripts.SingleoutputRosettaScriptsTask(refine)
        logging.info("Refinement protocol setup successfully")
    except Exception as e:
        logging.error(f"Error in setting up refinement protocol: {e}")
        raise
      
    # Mutation and pack
    ## Job distribution via `multiprocessing`

    with pyrosetta.distributed.utility.log.LoggingContext(logging.getLogger("rosetta"), level=logging.WARN):
        with Pool() as p:
            work = [
                (input_pose, i, aa, "mutation")
                for i, aa in itertools.product(selected_aa, IUPACData.protein_letters)
                #for i, aa in itertools.product(selected_aa, 'A')
            ]
            logging.info("mutating")
            try:
                mutations = p.starmap(mutate_residue, work)
                logging.info("Mutations completed successfully")
            except Exception as e:
                logging.error(f"Error during mutation process: {e}")
                raise
              
    # Sequential code for refinement without using dask
    if not os.getenv("DEBUG"):
        try:
            # Use dask for parallel refinement
            import dask.distributed
            cluster = dask.distributed.LocalCluster(n_workers=8, threads_per_worker=1)
            client = dask.distributed.Client(cluster)

            refinement_tasks = [client.submit(refine_mutation, mutant) for mutant in mutations]
            logging.info("refining")
            refinements = [task.result() for task in refinement_tasks]

            client.close()
            cluster.close()
            
            # sequential code for refinement without using dask
            #refinements = [refine_mutation(mutant) for mutant in mutations]
            #logging.info("Refinement completed successfully")
        except Exception as e:
            logging.error(f"Error during refinement process: {e}")
            raise
          
    if not os.getenv("DEBUG"):
        try:
            result_frame = pandas.DataFrame.from_records(packed_pose.to_dict(refinements))
            result_frame["delta_total_score"] = result_frame["total_score"] - input_pose.scores["total_score"] 
            result_frame["mutation_index"] = list(map(int, result_frame["mutation_index"]))
            logging.info("Results processed successfully")
        except Exception as e:
            logging.error(f"Error during result processing: {e}")
            raise
          
    if not os.getenv("DEBUG"):
        try:
            matplotlib.rcParams['figure.figsize'] = [24.0, 8.0]
            seaborn.heatmap(
                result_frame.pivot(index="mutation_aa", columns="mutation_index", values="delta_total_score"),
                cmap="RdBu_r", center=0, vmax=50)
            # save the heatmap
            matplotlib.pyplot.savefig("heatmap.png")
            # save the dataframe to a csv file
            result_frame.to_csv("ddg.csv")
            logging.info("Heatmap and CSV saved successfully")
        except Exception as e:
            logging.error(f"Error during heatmap or CSV saving: {e}")
            raise

    # save relaxed poses to PDB files
    for i, pose in enumerate(refinements):
        
        # get value 'mutation_index' from result_frame of ith row
        mutation_index = result_frame.iloc[i]['mutation_index']
        # get value 'mutation_aa' from result_frame of ith row
        mutation_aa = result_frame.iloc[i]['mutation_aa']
        pose.pose().dump_pdb(f"relaxed_{i}_{mutation_index}to{mutation_aa}.pdb")
        logging.info(f"Pose {i} saved successfully")

    #refine_mutation = rosetta_scripts.SingleoutputRosettaScriptsTask(refine)
    ## Mutation and pack
    ### Job distribution via `multiprocessing`
    #from multiprocessing import Pool
    #import itertools
    #
    #
    #
    #with pyrosetta.distributed.utility.log.LoggingContext(logging.getLogger("rosetta"), level=logging.WARN):
    #    with Pool() as p:
    #        work = [
    #            (input_pose, i, aa, "mutation")
    #            for i, aa in itertools.product(selected_aa, IUPACData.protein_letters)
    #            #for i, aa in itertools.product(selected_aa, 'A')
    #        ]
    #        logging.info("mutating")
    #        mutations = p.starmap(mutate_residue, work)
    #
    ##os.environ["DEBUG"] = "True"
    ##if not os.getenv("DEBUG"):
    ##    import dask.distributed
    ##    cluster = dask.distributed.LocalCluster(n_workers=1, threads_per_worker=1)
    ##    client = dask.distributed.Client(cluster)
    ##
    ##    refinement_tasks = [client.submit(refine_mutation, mutant) for mutant in mutations]
    ##    logging.info("refining")
    ##    refinements = [task.result() for task in refinement_tasks]
    ##
    ##    client.close()
    ##    cluster.close()
    #
    ## write a sequencial code, without using dask
    #if not os.getenv("DEBUG"):
    #    refinements = [refine_mutation(mutant) for mutant in mutations]
    #
    #
    #if not os.getenv("DEBUG"):
    #    result_frame = pandas.DataFrame.from_records(packed_pose.to_dict(refinements))
    #    result_frame["delta_total_score"] = result_frame["total_score"] - input_pose.scores["total_score"] 
    #    result_frame["mutation_index"] = list(map(int, result_frame["mutation_index"]))
    #
    #
    #if not os.getenv("DEBUG"):
    #    matplotlib.rcParams['figure.figsize'] = [24.0, 8.0]
    #    seaborn.heatmap(
    #        result_frame.pivot(index="mutation_aa", columns="mutation_index", values="delta_total_score"),
    #        cmap="RdBu_r", center=0, vmax=50)
    #    # save the heatmap
    #    matplotlib.pyplot.savefig("heatmap.png")
    #    # save the dataframe to a csv file
    #    result_frame.to_csv("ddg.csv")

if __name__ == "__main__":
    
    # Set up argument parser



    import argparse
    parser = argparse.ArgumentParser(description='Process some integers.')
    parser.add_argument('-p', '--pdb', type=str, required=True, help='Path to the PDB file')
    # Parse arguments
    args = parser.parse_args()

    data_pdb = args.pdb
    num_processors = os.cpu_count()
    selected_aa = range(1, 1+18)

    main(data_pdb, num_processors, selected_aa)
    

