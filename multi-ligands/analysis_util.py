import MDAnalysis as mda
from MDAnalysis.analysis import rms
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


def plot_radius_of_gyration(selection, university, time_scalar=1):
    """
    time_scalar: 1 means 1 ns, 1e-3 means 1 us per frame
    """
    rgyr = []
    for ts in university.trajectory:
        #time.append(university.trajectory.time)
        rgyr.append(selection.radius_of_gyration())

    # 提取frame的总数

    frame_len = university.trajectory.n_frames
    time = range(1,frame_len+1)
    time = [i * time_scalar for i in time]

    rgyr_df = pd.DataFrame(rgyr, columns=['Radius of gyration (A)'], index=time)
    rgyr_df.index.name = 'Time (ns)'
    rgyr_df.plot(title='Radius of gyration')


def plot_RMSD( university: mda.Universe, time_scaler=1, groupselections:list=None,ref=None):
    if groupselections is None:
        groupselections = ['protein']
    university.trajectory[0]  # set to first frame

    if ref:
        rmsd_analysis = rms.RMSD(university,ref, select='backbone',
                             groupselections=groupselections)  # select means first aligned by 'backbone'
    else:
        rmsd_analysis = rms.RMSD(university, select='backbone',groupselections=groupselections)  # select means first aligned by 'backbone'
    rmsd_analysis.run()

    #rmsd_analysis.results.rmsd[:, 1] *= time_scaler
    #将rmsd_analysis.results.rmsd[:, 1]替换为range(1,len(rmsd_analysis.results.rmsd[:, 1])+1)
    times = range(1,len(rmsd_analysis.results.rmsd[:, 1])+1)
    times = [i * time_scaler for i in times]
    rmsd_analysis.results.rmsd[:, 1] = times
    groupselections = [s.capitalize() for s in groupselections]
    rmsd_df = pd.DataFrame(rmsd_analysis.results.rmsd[:, 2:],
                           columns=['Backbone'] + groupselections,
                           index=rmsd_analysis.results.rmsd[:, 1])
    rmsd_df.plot(title='RMSD', xlabel='Time(ns)', ylabel='RMSD(Å)')
    return rmsd_df

def plot_RMSD_CA( university: mda.Universe, time_scaler=1, groupselections:list=None,ref=None):
    if groupselections is None:
        groupselections = ['protein']
    university.trajectory[0]  # set to first frame

    if ref:
        rmsd_analysis = rms.RMSD(university,ref, select='name CA',
                             groupselections=groupselections)  # select means first aligned by 'backbone'
    else:
        rmsd_analysis = rms.RMSD(university, select='name CA',groupselections=groupselections)  # select means first aligned by 'backbone'
    rmsd_analysis.run()

    #rmsd_analysis.results.rmsd[:, 1] *= time_scaler
    #将rmsd_analysis.results.rmsd[:, 1]替换为range(1,len(rmsd_analysis.results.rmsd[:, 1])+1)
    times = range(1,len(rmsd_analysis.results.rmsd[:, 1])+1)
    times = [i * time_scaler for i in times]
    rmsd_analysis.results.rmsd[:, 1] = times
    groupselections = [s.capitalize() for s in groupselections]
    rmsd_df = pd.DataFrame(rmsd_analysis.results.rmsd[:, 2:],
                           columns=['Backbone'] + groupselections,
                           index=rmsd_analysis.results.rmsd[:, 1])
    rmsd_df.plot(title='RMSD', xlabel='Time(ns)', ylabel='RMSD(Å)')
    return rmsd_df


def plot_rmsf(selection):
    """
    input selection:atomgroup
    return rmsfer, list(zip(range(1,len(selection.resnums)+1),selection.resnums))
    index in X axes start from 1, and is global index one by one in gro file

    usage:
        rmsfer.rmsf:array
        a list of tuple(global index start from 1, resnum)
    """
    rmsfer = rms.RMSF(selection).run()
    plt.plot(range(1,len(selection.resnums)+1), rmsfer.rmsf)
    plt.xlabel('residual index')
    plt.ylabel('RMSF(Å)')
    plt.title('RMSF')
    return rmsfer,list(zip(range(1,len(selection.resnums)+1),selection.resnums))


def save_rmsf_to_csv(selection, rmsfer: mda.analysis.rms.RMSF, out_file='RMSF.csv'):
    out = {
        'resindex': selection.resindices,
        'resnum': selection.resnums,
        'resname': selection.resnames,
        'RMSF': rmsfer.rmsf
    }
    df = pd.DataFrame(out)
    df.to_csv(out_file, index=False)
    print(f'Saved to {out_file}.')
