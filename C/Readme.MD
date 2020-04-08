# Recursive Watermark in C

This is an implementation of the following paper and released as Open Source Software under the MIT license. Please cite the following paper if you found the code useful. Thanks.

2020, Zhen Song (zhensong@ieee.org), Antun Skuric (antun.skuric@outlook.com), Kun Ji (kun.ji@siemens.com)
```
@Article{SongRWM2020,
  author   = {Z. {Song} and A. {Skuric} and K. {Ji}},
  title    = {A Recursive Watermark Method for Hard Real-Time Industrial Control System Cyber-Resilience Enhancement},
  journal  = {IEEE Transactions on Automation Science and Engineering},
  year     = {2020},
  pages    = {1-14},
  issn     = {1558-3783},
  doi      = {10.1109/TASE.2019.2963257},
  url 	   = {https://github.com/robot007/recursive_watermark}
}
```

## Note 
We compiled the code under Windows 10, with gcc from cygwin.

## RWM
```bash 
make rwm
gcc watermark_test_functions.c -o bin/rwm && bin/rwm && bin/rwm && bin/rwm && bin/rwm
```
* 99012.00 micros
* 99513.00 micros
* 109014.00 micros
* 94012.00 micros

Speed 0.1us

## MD5
```bash 
make md5
g++ md5.cpp md5_sample.cpp -o bin/md5_sample.exe && bin/md5_sample  && bin/md5_sample  && bin/md5_sample  && bin/md5_sample  && bin/md5_sample
```
* 4190532.00 micros
* 4005009.00 micros
* 3951502.00 micros
* 4138025.00 micros
* 4799110.00 micros

Speed 4us

## SHA256
```bash 
make sha
g++ sha256.cpp sha_sample.cpp -o bin/sha_sample.exe && bin/sha_sample && bin/sha_sample && bin/sha_sample && bin/sha_sample && bin/sha_sample
```
* 6688349.00 micros
* 6319802.00 micros
* 6974885.00 micros
* 11299935.00 micros
* 6260795.00 micros

Speed 7.4us