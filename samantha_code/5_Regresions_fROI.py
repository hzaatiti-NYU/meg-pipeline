
## RUN THIS *ipython* IN THE EELBRAIN ENVIRONMENT


# Samantha Wray 2023, based off of code from D. A. Chacón (2020) and Julien Dirani
# ---File structure----
# ROOT>
#     MRI>
#         subjs
#     MEG>
#         subjs
#     STC>

# epochs rejection based on log files not included


# ----------File structure-----------#
# ROOT>
#     MRI>
#         subjs
#     MEG>
#         subjs
#     STC>


import wx
#import os #for doing brain stuff
###os.environ['ETS_TOOLKIT'] = 'wx' #for doing brain plotting stuff

import csv
import itertools
import mne, eelbrain, os, glob, pickle
import numpy as np
import pandas as pd
from os.path import join
import os.path as op
from scipy.stats import zscore
from eelbrain import *
'''
import wx
import csv
import itertools
import mne, eelbrain, os, glob, pickle
import numpy as np
import pandas as pd
from os.path import join
import os.path as op
from scipy.stats import zscore
from eelbrain import *
# import statsmodels.formula.api as smf
#from statsmodels.formula.api import ols
#from numpy import npy_float64
'''
from time import sleep
import matplotlib.pyplot as plt

import os #for doing brain stuff
os.environ['ETS_TOOLKIT'] = 'wx' #for doing brain plotting stuff
import mne
import eelbrain
from surfer import Brain

mne.set_log_level(verbose='WARNING')
plottimecourses = True
plotbrains = False
override = True #for making it plot anyway
#=========Edit here=========#

SNR = 2 # 3 for ANOVAs, 2 for regressions
fixed = True # False for orientation free (=unsigned), True for fixed orientation (=signed)

from main import *

#del analyses
analyses = analyses_fROI

subjects = ['Y0119','Y0208','Y0312','Y0321','Y0368','Y0371','Y0367','Y0369','Y0373','Y0374','Y0378','Y0379','Y0381','Y0382','Y0387','Y0393','Y0395','Y0396']
subjects_jitter = []
date = '2022_Dec26'
sampleSize = 18
my_file = open("myfile.txt", "w")
output = os.path.join('new_ica/savant_main', 'Plots/Group/%s_Regressions_n%s/' %(date,str(sampleSize)))

if not os.path.exists(output):
    os.makedirs(output)
    os.makedirs(op.join(output,'clusters'))
    os.makedirs(op.join(output,'graphs'))
    os.makedirs(op.join(output,'csv'))
    os.makedirs(op.join(output,'results'))

#subjects_dir = os.path.join(ROOT, 'MRI')
exp = "savant_main"

#os.chdir(ROOT) #setting current dir
subjects_dir = ('new_ica/' + exp + '/mri')
for analysis in analyses:

#('M350 Analysis', (0.2, 0.5), ['LOBE.TEMPROAL-lh'], 'left temporal lobe', 'PALS_B12_Lobes', 'left', 'stemFrequency + wholeWordFreq', True, True, False),
    analysisType = analysis[0]
    time = analysis[1]
    sources = analysis[2]
    regionName = analysis[3]
    parc = analysis[4]
    hemi = analysis[5]
    formula = analysis[6]
    onlyCorrect = analysis[7]
    includeGram = analysis[8]
    includeViol = analysis[9]

    print('Conducting analysis %s' %analysisType)

    if hemi == "left":
        hemiShort = 'lh'
    elif hemi == "right":
        hemiShort = 'rh'
    elif hemi == "whole" or hemi == "both":
        hemiShort = 'whole'

    #if parc == 'aparc_sub':
    #    mne.datasets.fetch_aparc_sub_parcellation(subjects_dir=subjects_dir,verbose=True)


    # The dataset and the coefficient dictionary
    ds = Dataset()
    coefficientDict = dict()

    print("Computing regressions in %s from %s to %s'" %(parc, str(time[0]), str(time[1])))

    # Lists containing the subject factor and the beta values
    subjF = []
    test =[]
    betas = []

    for subj in subjects:
        regResFileName = op.join('new_ica/savant_main','Regressions/',subj,'Main',hemi,parc,str(time[0])+'-'+str(time[1]),formula+'.pickle')
        if os.path.exists(regResFileName):
            print('Regressions already done! Loading regression dSPM ~ 1 + %s for subject %s in %s from %s to %s' %(formula,subj,parc,str(time[0]),str(time[1])))
            regResF = open(regResFileName, 'rb')
            regRes = pickle.load(regResF)
            #test.append(regRes)
            regResF.close()
        else:
            print('Computing regression dSPM ~ 1 + %s for subject %s in %s from %s to %s' %(formula,subj,parc,str(time[0]),str(time[1])))

            ds_subj = Dataset()
            stcs = []

            stemFreqV = []
            wholeWordFreqV = []
            wordLengthV = []
            trProbV = []

            pos = []

            condF = []
            prefixF = []

            if not os.path.exists(op.join('Logs/%s-Savant_Ara.log' %subj)):
                print('No log file for %s :(' %subj)
            else:
                print('Found log file for %s' %subj)

                logFile = open(op.join('Logs','%s-Savant_Ara.log' %subj))
                if subj in subjects_jitter:
                    print(str(subj) + " jitter")
                    positionNo = 1
                else:
                    positionNo = 0
                for x in logFile:
                    if x.startswith("Picture\t") and ("hit" in x or "incorrect" in x) and "practice;" not in x:
# So we find the trial in the log file first...
# Presentation log files are weird...
# we only want to look at the bottom half of the
# log file; and we want to ignore practice trials
                        includeTrial = True
                        for fileName in os.listdir(os.path.join('stc_backup','savant_main',subj)):
                            #print("ok")
                            #print("file name is " + str(fileName))
# Then we get the fileName for the STC file
                            if (hemi == 'whole' or fileName.endswith(hemiShort+'.stc') or hemi == "both") and fileName.endswith('.stc'):
                                splitName = fileName.split('_')
                                #if 'Gramm' in fileName:
                                #    print("hello")
                                stcPosNo = int(splitName[1])
                                #print("stcPosno is " + str(stcPosNo) + " and position    No is " + str(positionNo))
                                if positionNo == stcPosNo:
#                                    print(x, fileName)
                                    splitLine = x.split('\t')
                                    #print(splitLine)
                                    wordCode = splitLine[1].split(';')[0] # this is the word in BCS/Slo
                                    #print(wordCode)
                                    wordCode = wordCode.replace('_',' ')
                                    #print(wordCode)
                                    #my_file.write(wordCode)
                                    #my_file.write('\n')
#                                    print(wordCode)
                                    correctOrNot = splitLine[2]

#                                    if onlyCorrect:
#                                        if "hit" not in correctOrNot:
#                                            includeTrial = False
#                                            print(splitLine)
#                                            print("%s missed trial %s word %s" %(subj, str(positionNo), wordCode))

                                    if includeViol == False:
                                        if 'SemViol' in fileName or 'CatViol' in fileName:
                                            includeTrial = False
                                            #print("Excluding violation trial %s word %s for subject %s" %(str(positionNo), wordCode, subj))

                                    if includeGram == False:
                                        if 'Gramm' in fileName:
                                            includeTrial = False

                                    if 'Filler' in fileName:
                                            includeTrial = False
                                            #print("Excluding grammatical trial %s word %s for subject %s" %(str(positionNo), wordCode, subj))

                                    if includeTrial:
                                        #print("Including trial %s %s for %s" %(str(positionNo), wordCode, subj))
                                        regressorF = open(regressorFile, "r")
                                        #mylist = list(csv.DictReader(regressorF))
                                        regressorF.seek(0)
                                        #my_file.write(str(len(mylist)))
                                    # Now that we've found the trial, and excluded the incorrect answers (if necessary),
                                    # we'll open the regressors file and get the variables that we want

                                        for y in csv.DictReader(regressorF):

                                            #print(len(csv.DictReader(regressorF)))
                                            #print(wordCode)
                                            #my_file.write(wordCode)
                                            #my_file.write('\t')
                                            #my_file.write(y['Word'])
                                            #my_file.write('\n')


                                            if wordCode == y['Word']:
                                                #print("found")
                                                #my_file.write("found")
                                                print("Found trial %s %s for %s" %(str(positionNo), wordCode, subj))
                                                if len(y['WWord.Freq(PerM)']) > 0:
                                                    #print(y['WWord.Freq(PerM)'])
                                                    wordFreq = float(y['WWord.Freq(PerM)'])
                                                    #f.write(str(y['WWord.Freq(PerM)']))
                                                else:
                                                    wordFreq = 0.0
                                                if len(y['Stem.freq(Per.M)']) > 0:
                                                    stemFreq = float(y['Stem.freq(Per.M)'])
                                                else:
                                                    stemFreq = 0.0
                                                wordLength = float(y['length'])
                                                trProb = float(y['TP'])
                                            else:
                                                #print("not a match")
                                                #notfound[wordCode] = 1
                                                nomatch = 1

                                        regressorF.close()

                                        print("attempting to load stc" + str(fileName))
                                        tmp = mne.read_source_estimate('stc_backup/savant_main/%s/%s' %(subj,fileName),subject=subj)
                                        stcs.append(tmp)
                                        if len(stcs) == 0:
                                            print("error")
                                        else:
                                            print("no error")
                                        pos.append(positionNo)
                                        if 'Gramm' in fileName:
                                            condF.append('Gramm')
                                            wholeWordFreqV.append(wordFreq)
                                            stemFreqV.append(stemFreq)
                                            wordLengthV.append(wordLength)
                                            trProbV.append(trProb)
                                            print("grammatical trial")
                                            #elif 'ArgStrViol' in fileName:
                                            #    condF.append('ArgStrViol')
                                            #    wholeWordFreqV.append(0)
                                            #    stemFreqV.append(0)
                                            #    wordLengthV.append(5)
                                            #    trProbV.append(0)
                                        elif 'CatViol' in fileName:
                                            condF.append('CatViol')
                                            wholeWordFreqV.append(0)
                                            stemFreqV.append(0)
                                            wordLengthV.append(5)
                                            trProbV.append(0)
                                            print("violation trial")
                                        elif 'Filler' in fileName:
                                            condF.append('Filler')
                                            wholeWordFreqV.append(0)
                                            stemFreqV.append(0)
                                            wordLengthV.append(5)
                                            trProbV.append(0)
                                            print("filler trial")
                                        else:
                                            condF.append('SemViol')
                                            wholeWordFreqV.append(0)
                                            stemFreqV.append(0)
                                            wordLengthV.append(5)
                                            trProbV.append(0)
                                            print("violation trial")

                                            #if 'SemViol' in fileName or 'CatViol' in fileName:
                                            #    prefixF.append(splitName[2][7:])
                                            #33elif 'Gramm' in fileName:
                                            #    prefixF.append(splitName[2][5:])
                                        #else:
                                        #    prefixF.append('Filler')



                        positionNo += 1


                logFile.close()
            print(len(stcs))
            print('Loading fiff...')
            ds_subj['stcs'] = load.fiff.stc_ndvar(stcs, subject='fsaverage', src='ico-4', subjects_dir=subjects_dir, parc=parc)
            eelbrain.load.update_subjects_dir(ds_subj, subjects_dir=subjects_dir, depth=-1)
            print('Done.')

            print('Subsetting the regions...')
            stc = ds_subj['stcs']
            stc_region = stc.sub(source=sources)
            ds_subj['stcs'] = stc_region
            print('Done.')

            print('Assigning factors to the DS...')

            ds_subj['wordLength'] = Var(wordLengthV)
            ds_subj['stemFreq'] = Var(stemFreqV)
            ds_subj['wholeWordFreq'] = Var(wholeWordFreqV)
            ds_subj['wordLength'] = Var(wordLengthV)
            ds_subj['TP'] = Var(trProbV)
            ds_subj['condition'] = Factor(condF,labels={'Gramm':'Gramm','Filler':'Filler','CatViol':'CatViol','SemViol':'SemViol'})
            #ds_subj['prefix'] = Factor(prefixF)


            nd = ds_subj['stcs'].x
            nd = np.array(ds_subj['stcs'].x, dtype='float64')
            ds_subj['stcs'].x = nd
            print('Done.')

            print('Beginning regression...')
            regRes = testnd.LM(ds_subj['stcs'].mean('source'),model=formula,ds=ds_subj)


            if not os.path.exists(op.join('new_ica/savant_main','Regressions',subj,'Main',hemi,parc,str(time[0])+'-'+str(time[1]))):
                os.makedirs(op.join('new_ica/savant_main','Regressions',subj,'Main',hemi,parc,str(time[0])+'-'+str(time[1])))

            pickle.dump(regRes, open(regResFileName, 'wb'),protocol=4)

            del ds_subj, stcs, tmp

        for coef in regRes.column_names:
            if coef not in coefficientDict:
                coefficientDict[coef] = []
            coefficientDict[coef].append(regRes.coefficient(coef))

        subjF.append(subj)


    for coef in coefficientDict.keys():

#                    stc_region = stc.sub(source=sources)

        ds = Dataset()
        ds['beta'] = coefficientDict[coef]

#                    for stc in ds['beta']:
#                        stc_region = stc[0].sub(source=sources)
#                        ds['beta'][stc] = stc_region

        ds['subject'] = Factor(subjF, random=True)
        eelbrain.load.update_subjects_dir(ds, subjects_dir=subjects_dir, depth = -1)
        print("parc name is " + str(parc))

        for t in [-1, 1]:

            res_fname = op.join(output, coef, 'results', hemi + '_' + parc + '_' + str(t) + '_' + str(time[0]) + '-' + str(time[1]) + '_' + analysisType + '_' + coef + '_spatiotemporal.pickle')
            res_table = op.join(output, coef, 'table', hemi + '_' + parc + '_' + str(t) + '_' + str(time[0]) + '-' + str(time[1]) + '_' + analysisType + '_' + coef + '_spatiotemporal_results_table.txt')

            if os.path.exists(res_fname):
                print('Already exists for ' + coef + ' in ' + regionName)

            elif coef == 'intercept':
                print('Ignoring intercept')
                if not os.path.exists(op.join(output,coef)):
                    os.makedirs(op.join(output,coef,'results'))
                    os.makedirs(op.join(output,coef,'table'))
                pickle.dump(ds, open(res_fname, 'wb'),protocol=4)

            elif 'condition' in coef:
                if not os.path.exists(op.join(output,coef)):
                    os.makedirs(op.join(output,coef,'results'))
                    os.makedirs(op.join(output,coef,'table'))
                ds_fname = op.join(output, coef, 'results', hemi + '_' + parc  + '_' + str(t) + '_' + str(time[0]) + '-' + str(time[1]) + '_' + analysisType + '_' + coef + '_betas.pickle')
                pickle.dump(ds, open(ds_fname, 'wb'),protocol=4)

            if coef != "intercept" and not os.path.exists(res_fname):
                if not os.path.exists(op.join(output,coef,'results')):
                    os.makedirs(op.join(output,coef,'results'))
                    os.makedirs(op.join(output,coef,'table'))

            # n = coefficient number
            # j = subject number
                res = testnd.ttest_1samp('beta', ds=ds,
                tstart=time[0], tstop=time[1],
                pmin = pmin,
                tail = t,
                force_permutation=True,
                mintime = mintime,
                #tfce = True,
                samples = samples
                #match='subject'
                )

                pickle.dump(res, open(res_fname, 'wb'),protocol=4)

                f = open(res_table, 'w')
                f.write(str(res.clusters))
                f.close()

                # plot clusters that are significant at alpha level 0.10
                plot_pmin = 0.10
                mask_sig_clusters = np.where(res.clusters['p'] <= plot_pmin, True, False)
                sig_clusters = res.clusters[mask_sig_clusters]

                if sig_clusters.n_cases != None:

                    for i in range(sig_clusters.n_cases):

                        cluster_nb = i + 1

                        cluster = sig_clusters[i]['cluster']
                        tstart = sig_clusters[i]['tstart']
                        tstop = sig_clusters[i]['tstop']
                        clusterp = str(sig_clusters[i]['p'])

                        cluster_fname = op.join(output, 'clusters', hemi + '_' + parc + '_' + str(t) + '_' + str(tstart) + '-' + str(tstop) + '_' + str(cluster_nb) + '_' + analysisType + '_' + coef + '_p' + clusterp + '.pickle')

                        timecourse = combine(ds['beta'])
                        clusterNTuple = (res_fname,# res_fname
                            res_table, # res_table
                            cluster, # cluster
                            tstart, # tstart
                            tstop, # tstop
                            coef, # coefficient
                            #region, # regionName
                            parc, # regionName
                            timecourse, # timecourse
                            hemi, # hemi
                            sources, # region
                            analysisType, # analysisType
                            cluster_nb, # cluster number
                            ds, # data
                            time[0], # original start time
                            time[1], # original stop time
                            clusterp # cluster p-value
                        )



                        pickle.dump(clusterNTuple,open(cluster_fname, 'wb'),protocol=4)

my_file.close()

######### Plotting #######

clustersToPlot = []

for fileName in os.listdir(op.join(output, 'clusters')):

    if fileName.endswith('pickle'):
        clusFile = open(op.join(output, 'clusters', fileName), 'rb')
        clus = pickle.load(clusFile)
        clusFile.close()
        clustersToPlot.append(clus)

for clus in clustersToPlot:
    res_fname = clus[0]
    res_table = clus[1]
    cluster = clus[2]
    tstart = clus[3]
    tstop = clus[4]
    coef = clus[5]
    clusterParc = clus[6]
    timecourse = clus[7]
    hemi = clus[8]
    region = clus[9]
    analysisType = clus[10]
    cluster_nb = clus[11]
    ds = clus[12]
    p_start = clus[13]
    p_stop = clus[14]
    clusP = clus[15]

    eelbrain.load.update_subjects_dir(cluster, subjects_dir=subjects_dir, depth = -1)
    eelbrain.load.update_subjects_dir(ds, subjects_dir=subjects_dir, depth = -1)

    multiClusters = {}

    graphName = op.join(output, 'graphs','%s_%s_cluster%s_%s-%s_%s-%s_%s_%s_p%s.png' %(hemi,clusterParc,cluster_nb,str(tstart),str(tstop),str(p_start),str(p_stop),analysisType,coef,str(clusP)))

    #if os.path.exists(graphName):
    #    print('Cluster already plotted')
    if override == True:

        ########################################################################
        ########################################################################
        # Plotting coefficient time course
        ########################################################################
        ########################################################################
        if plottimecourses:

            print('Plotting time series for %s %s from %s' %(hemi,clusterParc,tstart))

            #labels = eelbrain.labels_from_clusters(cluster)

            #mne.write_labels_to_annot(labels,subject = 'fsaverage',subjects_dir=subjects_dir,
            #    overwrite=True,
            #    parc = coef + 'Cluster' + date
            #    )
            #labels = mne.read_labels_from_annot(subject='fsaverage', subjects_dir=subjects_dir,
            #    parc = coef + 'Cluster' + date
            #    )

            #stc = ds['stcs']
            #stc_region = stc.sub(source=region)
            #ds['stcs'] = stc_region

            stc = combine(ds['beta'])
            #stc_region = stc.sub(source=region)
            ds['beta'] = stc

            timecourse = stc
            #timecourse = timecourse

            #is this successfully subsetting with the region of interest

            activation = plot.UTSStat(timecourse, #x='intercept',#xeffect,
                ds = ds,
                error='sem',
                error_alpha = 0.10,
                legend = None,
                xlabel = 'Time (ms)',
                ylabel = 'Beta values', #what is being plotted here? is this beta values?
                xlim = (epoch_tmin, epoch_tmax),
                show = False,
                title = 'Beta values of %s cluster in %s' %(coef, clusterParc)  #what is being plotted here? is this beta values?
                )
            activation.add_vspan(xmin=tstart, xmax=tstop, color='lightgrey', zorder=-50, alpha=0.4)
            activation._axes[0].set_xticks([0,tstart,tstop])

            for j in range(0,len(activation._axes[0].lines)):
                activation._axes[0].lines[j].set_lw(w=0.75)
            activation._axes[0].axvline(x=0.0,color="black",linestyle=":")
            activation.save(graphName, dpi=300)
            sleep(10)

            try:
                activation.close()
            except:
                print("Can't close activation plot")


            ########################################################################
            ########################################################################
            # Plotting intercept time course
            ########################################################################
            ########################################################################

            print('Plotting time series for %s at %s %s from %s' %(coef,hemi,regionName,tstart))

            intercept_fname = op.join(output, 'intercept', 'results', hemi + '_' + clusterParc + '_' + '1' + '_' + str(p_start) + '-' + str(p_stop) + '_' + analysisType + '_' + 'intercept' + '_spatiotemporal.pickle')
            intercept_file = open(intercept_fname, 'rb')
            intercept = pickle.load(intercept_file)
            intercept_file.close()
            stc = combine(intercept['beta'])

            src = stc
            #src.source.set_parc('Tark_FROI_left-lh')
            #src.set_parc('Tark_FROI_left-lh')
            #src_region = src.sub(source='Tark_FROI_left-lh')
            #stc_region = stc.sub(source=labels[0])
            int_timecourse = src
            #.mean('source')
            #intercept['beta'] = stc_region

            effect_timecourse = int_timecourse + timecourse

            ds['intercept'] = intercept['beta']


            ########################################################################
            ########################################################################
            # Plotting intercept vs. coefficient time course
            ########################################################################
            ########################################################################

            print("Printing fitted values for coefficient...")

            activation = plot.UTSStat(int_timecourse,
                ds = intercept,
                error='sem',
                error_alpha = 0.10,
                legend = None,
                xlabel = 'Time (ms)',
                ylabel = 'Predicted dSPM',
    #            xlim = (epoch_tmin, epoch_tmax),
                show = False,
                title = str('Intercept at ' + regionName)
                )
            activation.add_vspan(xmin=tstart, xmax=tstop, color='lightgrey', zorder=-50, alpha=0.4)
            activation._axes[0].set_xticks([0,tstart,tstop])

            for j in range(0,len(activation._axes[0].lines)):
                activation._axes[0].lines[j].set_lw(w=0.75)

            activation._axes[0].axvline(x=0.0,color="black",linestyle="solid")

            activation._axes[0].grid()

            interceptYlim = activation.get_ylim()

            #coef = coef.replace('/','')
            #coef = coef.replace(':','')

            graphName = op.join(output, 'graphs','%s_%s_cluster%s_%s-%s_%s-%s_%s_%s_p%s_intercept.png' %(hemi,clusterParc,cluster_nb,str(tstart),str(tstop),str(p_start),str(p_stop),analysisType,coef,str(clusP)))

            activation.save(graphName, dpi=300)
            sleep(15)
            try:
                activation.close()
            except:
                print("Can't close activation plot")

            fig, axes = plt.subplots()

            plt.plot(int_timecourse.mean(dims='case'),'black',label='Intercept',linewidth=0.75,linestyle='dashed')
            plt.plot(effect_timecourse.mean(dims='case'),'blue',label=coef,linewidth=0.75)

            #print(tstart)
            #print(tstop)

            #fixedTStart = int(round(tstart,3) * 100) + 110
            #fixedTStop = int(round(tstop,3) * 100) + 110
            fixedTStart = (tstart*1000)+200
            fixedTStop = (tstop*1000)+200

            tStartName = str(fixedTStart)
            tStopName = str(fixedTStop)

            tStartName = str(int(round(tstart,3)*1000))
            tStopName = str(int(round(tstop,3)*1000))

            #print(fixedTStart)
            #print(fixedTStop)

            if ':' in coef:
                fig.suptitle("Intercept vs. Coefficient for %s in %s %s cluster, %s - %s ms" %(str(coef.split(':')[0]),hemi,clusterParc,tStartName,tStopName))
            else:
                fig.suptitle("Intercept vs. Coefficient for %s in %s %s cluster, %s - %s ms" %(coef,hemi,clusterParc,tStartName,tStopName))


            axes.set_xticks([0,100,200,300,400,500,600,700,800])
            axes.set_xticklabels(['-200','','0','','200','','400','','600'])

            axes.axvline(x=200,color="black",linestyle="solid")

            axes.axvspan(fixedTStart, fixedTStop, alpha=0.2,color="grey")

            interceptYlim = activation.get_ylim()

            axes.set_ylim(ymin=-1*max(abs(interceptYlim[0]),abs(interceptYlim[1])),
                ymax=max(abs(interceptYlim[0]),abs(interceptYlim[1])))

            axes.set_ylabel("Fitted Activation (dSPM)")
            axes.set_xlabel("Time (ms)")

            axes.legend(loc="lower left")

            axes.spines['top'].set_visible(False)
            axes.spines['left'].set_visible(False)
            axes.spines['right'].set_visible(False)

            fig.set_figwidth(10)
            fig.set_figheight(4)

            #coef = coef.replace('/','')
            #coef = coef.replace(':','')

            graphName = op.join(output, 'graphs','%s_%s_cluster%s_%s-%s_%s-%s_%s_%s_p%s_effVsInt.png' %(hemi,clusterParc,cluster_nb,str(tstart),str(tstop),str(p_start),str(p_stop),analysisType,coef,str(clusP)))

            fig.savefig(graphName, dpi=300)



        ########################################################################
        ########################################################################
        # Plotting brain
        ########################################################################
        ########################################################################
        #sleep(20)
        if plotbrains:
            if hemi == 'left':
                brainside = 'lh'
    #            if oppositeHemi:
    #                brainside = 'rh'
            elif hemi == "right":
                brainside = 'rh'
    #            if oppositeHemi:
    #                brainside = 'lh'
            else:
                brainside = 'split'
            #parc = mne.read_labels_from_annot('fsaverage',clusterParc,subjects_dir=subjects_dir,hemi=hemiShort) #read in the parcellation here. Typical options are aparc or Brodmann
            #labels = [i for i in parc]
            #label = labels[0]
            #print(label)
            brain = plot.brain.annot(clusterParc, hemi=brainside,
            alpha=1,
            borders=True,
            subject='fsaverage',
            background='white',
            title = "fROI for %s in %s %s from %s – %s" %(coef, hemi, clusterParc, str(tstart), str(tstop)),
    #        vmin = -2.0,
            surf = 'inflated',
            views = ['lateral','medial','rostral',
            'ventral'],
            subjects_dir=subjects_dir)


            #brain.add_label(label,color="black",borders=True) #plot your ROI



            graphName = op.join(output, 'graphs','%s_%s_cluster%s_%s-%s_%s-%s_%s_%s_p%s_brain.png' %(hemi,regionName,cluster_nb,str(tstart),str(tstop),str(p_start),str(p_stop),analysisType,coef,str(clusP)))

            brain.save_image(graphName)
            sleep(15)
            try:
                brain.close()
            except:
                print("Can't close brain")
