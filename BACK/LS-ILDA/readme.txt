This package is the implementation of our LS-ILDA algorithm [1]. 

ATTN: This package is free for academic usage. You can run it at your own risk. 
      For other purposes, please contact Prof. Zhi-Hua Zhou (zhouzh@nju.edu.cn).

Requirement: The package was developed with MATLAB (v2008a)

The LS-ILDA algorithm is an incremental version of the least-square linear discriminant analysis. 
When a new instance comes, instead of computing discriminant components from scratch, LS-ILDA 
updates components obtained in last step. It has two updating mode, according to whether the dimention 
is larger than than the number of instances (see the paper for detail). 

The first updating mode is implemented in files with '1'(runLS_ILDA1.m, initLS_ILDA1.m, LS_ILDA1.m).
You can simply run runLS_ILDA1.m to get a result, since the data of face dataset ORL [2] is included 
in this package as an example.  

Similarly, the second updating mode is implemented in files with '2'(runLS_ILDA2.m, initLS_ILDA2.m, 
LS_ILDA2.m). You can also run the second updating method with sample data reduced from the ORL dataset.

This package was developed by Mr. Li-Ping Liu (liulp@lamda.nju.edu.cn). For any problem concerning the 
code, please feel free to contact Mr. Liu.

[1] L.-P. Liu, Y. Jiang, and Z.-H. Zhou. Least square incremental linear discriminant analysis. In: 
    Proceedings of the 9th IEEE International Conference on Data Mining (ICDM'09), Miami, FL, 2009, 
    pp.298-306.
[2] http://www.cs.uiuc.edu/homes/dengcai2/Data/FaceData.html