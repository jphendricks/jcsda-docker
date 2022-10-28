import h5py
import numpy as np

with h5py.File("mytestfile.hdf5", "w") as f:

    dset = f.create_dataset("mydataset", (100,), dtype='i')
    print('dset.name - ', dset.name)
    print('f.name    - ', f.name)
