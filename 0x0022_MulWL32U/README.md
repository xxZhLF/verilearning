基于 Wallace 树的 32-Bit 乘法器。

逻辑区分：组合逻辑


本质为：对32个 64-Bit 部分积求和的，进位保存加法器构成的加法器树，将N个数3个1组进行分组。

       X31 X30 X29         X28 X27 X26         X25 X24 X23         X22 X21 X20         X19 X18 X17         X16 X15 X14         X13 X12 X11         X10 X9  X8          X7  X6  X5          X4  X3  X2       X1   X0 
       |   |   |           |   |   |           |   |   |           |   |   |           |   |   |           |   |   |           |   |   |           |   |   |           |   |   |           |   |   |        |    |  
    +---+---+---+---+   +---+---+---+---+   +---+---+---+---+   +---+---+---+---+   +---+---+---+---+   +---+---+---+---+   +---+---+---+---+   +---+---+---+---+   +---+---+---+---+   +---+---+---+---+   |    |  
    |   32-Bit SCA  |   |   32-Bit SCA  |   |   32-Bit SCA  |   |   32-Bit SCA  |   |   32-Bit SCA  |   |   32-Bit SCA  |   |   32-Bit SCA  |   |   32-Bit SCA  |   |   32-Bit SCA  |   |   32-Bit SCA  |   |    |  
    +-----+---+-----+   +-----+---+-----+   +-----+---+-----+   +-----+---+-----+   +-----+---+-----+   +-----+---+-----+   +-----+---+-----+   +-----+---+-----+   +-----+---+-----+   +-----+---+-----+   |    |  
          |S  |C << 1         |S  |C << 1         |S  |C << 1         |S  |C << 1         |S  |C << 1         |S  |C << 1         |S  |C << 1         |S  |C << 1         |S  |C << 1         |S  |C << 1   |    |  
          |   |               |   |               |   |               |   |               |   |               |   |               |   |               |   |               |   |               |   |         |    |  
          |   +-------+   +---+   +---+   +-------+   |               |   +-------+   +---+   +---+   +-------+   |               |   +-------+   +---+   +---+   +-------+   |               |   |   +-----+    |  
          +-------+   |   |           |   |   +-------+               +-------+   |   |           |   |   +-------+               +-------+   |   |           |   |   +-------+               |   |   |          |  
                  |   |   |           |   |   |                               |   |   |           |   |   |                               |   |   |           |   |   |                       |   |   |          |  
              +---+---+---+---+   +---+---+---+---+                       +---+---+---+---+   +---+---+---+---+                       +---+---+---+---+   +---+---+---+---+               +---+---+---+---+      |  
              |   32-Bit SCA  |   |   32-Bit SCA  |                       |   32-Bit SCA  |   |   32-Bit SCA  |                       |   32-Bit SCA  |   |   32-Bit SCA  |               |   32-Bit SCA  |      |  
              +-----+---+-----+   +-----+---+-----+                       +-----+---+-----+   +-----+---+-----+                       +-----+---+-----+   +-----+---+-----+               +-----+---+-----+      |  
                    |S  |C << 1         |S  |C << 1                             |S  |C << 1         |S  |C << 1                             |S  |C << 1         |S  |C << 1                     |S  |C << 1      |  
                    |   |               |   |                                   |   |               |   |                                   |   |               |   |                           |   |            |  
                    |   +-------+   +---+   +-----------------------+   +-------+   |               |   +-------+   +-----------------------+   +---+   +-------+   |                           |   |            |  
                    +-------+   |   |                               |   |   +-------+               +-------+   |   |                               |   |   +-------+                           |   |   +--------+  
                            |   |   |                               |   |   |                               |   |   |                               |   |   |                                   |   |   |           
                        +---+---+---+---+                       +---+---+---+---+                       +---+---+---+---+                       +---+---+---+---+                           +---+---+---+---+       
                        |   32-Bit SCA  |                       |   32-Bit SCA  |                       |   32-Bit SCA  |                       |   32-Bit SCA  |                           |   32-Bit SCA  |       
                        +-----+---+-----+                       +-----+---+-----+                       +-----+---+-----+                       +-----+---+-----+                           +-----+---+-----+       
                              |S  |C << 1                             |S  |C << 1                             |S  |C << 1                             |S  |C << 1                                 |S  |C << 1       
                              |   |                                   |   |                                   |   |                                   |   |                                       |   |             
                              |   +-------+   +-----------------------+   +-----------------------+   +-------+   |                                   |   +-------+   +---------------------------+   |             
                              +-------+   |   |                                                   |   |   +-------+                                   +-------+   |   |                               |             
                                      |   |   |                                                   |   |   |                                                   |   |   |                               |             
                                  +---+---+---+---+                                           +---+---+---+---+                                           +---+---+---+---+                           |             
                                  |   32-Bit SCA  |                                           |   32-Bit SCA  |                                           |   32-Bit SCA  |                           |             
                                  +-----+---+-----+                                           +-----+---+-----+                                           +-----+---+-----+                           |             
                                        |S  |C << 1                                                 |S  |C << 1                                                 |S  |C << 1                           |             
                                        |   |                                                       |   |                                                       |   |                                 |             
                                        |   +-------+   +-------------------------------------------+   +-------------------------------------------+   +-------+   |                                 |             
                                        +-------+   |   |                                                                                           |   |   +-------+                                 |             
                                                |   |   |                                                                                           |   |   |                                         |             
                                            +---+---+---+---+                                                                                   +---+---+---+---+                                     |             
                                            |   32-Bit SCA  |                                                                                   |   32-Bit SCA  |                                     |             
                                            +-----+---+-----+                                                                                   +-----+---+-----+                                     |             
                                                  |S  |C << 1                                                                                         |S  |C << 1                                     |             
                                                  |   |                                                                                               |   |                                           |             
                                                  |   +-------+   +-----------------------------------------------------------------------------------+   |                                           |             
                                                  +-------+   |   |                                                                                       |                                           |             
                                                          |   |   |                                                                                       |                                           |             
                                                      +---+---+---+---+                                                                                   |                                           |             
                                                      |   32-Bit SCA  |                                                                                   |                                           |             
                                                      +-----+---+-----+                                                                                   |                                           |             
                                                            |S  |C << 1                                                                                   |                                           |             
                                                            |   |                                                                                         |                                           |             
                                                            |   +-------+   +-----------------------------------------------------------------------------+                                           |             
                                                            +-------+   |   |                                                                                                                         |             
                                                                    |   |   |                                                                                                                         |             
                                                                +---+---+---+---+                                                                                                                     |             
                                                                |   32-Bit SCA  |                                                                                                                     |             
                                                                +-----+---+-----+                                                                                                                     |             
                                                                      |S  |C << 1                                                                                                                     |             
                                                                      |   |                                                                                                                           |             
                                                                      |   +-------+   +---------------------------------------------------------------------------------------------------------------+             
                                                                      +-------+   |   |                                                                                                                             
                                                                              |   |   |                                                                                                                             
                                                                          +---+---+---+---+                                                                                                                         
                                                                          |   32-Bit SCA  |                                                                                                                         
                                                                          +-----+---+-----+                                                                                                                         
                                                                                |S  |C << 1                                                                                                                         
                                                                                |   |                                                                                                                               
                                                                          +-----+---+-----+                                                                                                                         
                                                                          |   32-Bit SCA  |                                                                                                                         
                                                                          +-------+-------+                                                                                                                         
                                                                                  |S                                                                                                                                
从其结构来看，该乘法器由8层进位保存加法器与1层先行进位加法器构成， \
因此其**深度为：16+5=21**。与仅由先行进位加法器构成的乘法器相比，少了8层的延迟。