import h5py
import numpy as np
import os

gems2_path = '/home/johnny/src/omsutils'
gems2_file = 'GEMS2Amethyst_L1B_1590973896_1656680913.hdf5'
gems2_filepath = os.path.join(gems2_path, gems2_file)

print('reading : ', gems2_filepath)

with h5py.File(gems2_filepath, 'r') as f:
    print(list(f.keys()))
    for key in f.keys():
        dset = f[key]
        print('key - ', key)
        for mem in dset.keys():
            dmem = dset[mem]
            print('   member - ', mem, dmem.shape, '"', dmem.dtype, '"')

f = h5py.File(gems2_filepath, 'r')
datasetNames = [n for n in f.keys()]

print('---datasetNames---')
for n in datasetNames:
    print(n)

tbDset = f['radiometric_data']['main_beam_antenna_temperatures']
tbData = np.array(tbDset)

tbDims = tbDset.shape
print('tbDims = ', tbDims)

numLocs = tbDims[0]
numChans = tbDims[1]

print('numLocs  = ', numLocs)
print('numChans = ', numChans)

tbName = "ObsValue/main_beam_antenna_temperatures"
latName = "MetaData/latitude"
lonName = "MetaData/longitude"

# key -  geolocation_data
#    member -  latitude (856440,) " float64 "
#    member -  longitude (856440,) " float64 "

latDset = f['geolocation_data']['latitude']
lonDset = f['geolocation_data']['longitude']

latData = np.array(latDset)
lonData = np.array(lonDset)

print('lat_min = ', np.min(latData))
print('lat_max = ', np.max(latData))
print('')
print('lon_min = ', np.min(lonData))
print('lon_max = ', np.max(lonData))
print('')
print('tb_min = ', np.min(tbData))
print('tb_max = ', np.max(tbData))
