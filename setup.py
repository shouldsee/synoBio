#!/usr/bin/env python2
#from setuptools import setup
from distutils.core import setup
#from setuptools import setup, find_packages



#from pip.req import parse_requirements
#required = parse_requirements('requirements.txt', session='hack')
#with open('requirements.txt') as f:
#    required = f.read().splitlines()


required = []
pkgs = ['synoBio']
# pkgs = find_packages(pkgs,exclude=['tests'])
# print pkgs
# print required
setup(
	name='synoBio',
	version='0.1',
# 	packages=['wraptool',
# #               'pymisca.tensorflow_extra_',
# #              'pymisca.model_collection',
# #              'pymisca.iterative',
#              ],
    packages = pkgs,
#    namespace_packages = pkgs,
    package_dir={'synoBio':'synoBio'},
    package_data={'synoBio': ['*.sh','*.json','*.csv','*.tsv','*.npy','*.pk',
                             'resources/*','genomeConfigs/*',],
#                  'runtime_data':['wraptool/*.{ext}'.format(**locals()) 
#                                  for ext in 
#                                  ['json','csv','tsv','npy','pk']],
                 },
    include_package_data=True,
#	zip_safe = False,
    
# 	license='GPL3',
	author='Feng Geng',
	author_email='fg368@cam.ac.uk',
# 	long_description=open('README.md').read(),
#	install_requires,
	install_requires = required,
#		['numpy',
#		'scipy',
#		'matplotlib',]
)
