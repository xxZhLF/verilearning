单周期指令架构

逻辑区分：组合逻辑 \
（所有模块均已组合逻辑方式连接，
时钟用于驱动寄存器文件与PC。）

                                         +-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+ 
                                         |                                                                                                                                                                               | 
              +----------------+---------|------------------------------------------------------------+                                                                                                                  | 
              |                |         |                                                            |                                                                                                                  | 
              |  +-------------|--+------|---------------------------------------------------------+  |                                                                                                                  | 
              |  |             |  |      |                                                         |  |                                                                                                                  | 
           +--+--+--+       +--+--+--+   |                             +----------------+----------|--+-----------+---------------------------------------------------+----------+--------------------+                  | 
           | Byte   |       | Read   |   |                             |                |          |              |                                                   |          |                    |                  | 
       +-<-+ Half   |   +-<-+ or     |   |                             |  +----------+--|----------+-----------+--|------------------------------------------------+--|-------+--|-----------------+  |                  | 
       |   | Word   |   |   | Write  |   |                             |  |          |  |                      |  |                                                |  |       |  |                 |  |                  | 
       |   +--------+   |   +--------+   |               |             |  |       +--+--+--+                   |  |                                                |  |       |  |               +-+---+-+               | 
       |                |                |            clk|             |  |       | Brench |                   |  |                                                |  |       |  |               |  ALU  |               | 
       |   +------------+                |        +------+---+         |  |  +--<-+ or     +-<--+              |  |                                                |  |       |  |               |  Ctl  |               | 
       |   |                             |    Next|     \ /  |mode     |  |  |    | Jump   |    |              |  |                                                |  |       |  |               +---+---+               | 
       |   |                             +------<-+ PC   +   +-<-------|--|--+    +--------+    |              |  |                                                |  |       |  |                   |                   | 
       |   |                                      |          |target   |  |                     |              |  |                                                |  |       |  |                   |                   | 
       |   |                                  Addr|          +-<-------|--|---------------------+--------------|--|------------------------------------------------|--|-------|--|-------------------|----------------+  | 
       |   |                 |           +------<-+          |offset   |  |                                    |  |                                                |  |       |  |                   |                |  | 
       |   |              clk|           |        |          +-<-------|--|--------------------------+         |  |                                              +-+--+-+     |  |                   |                |  | 
       |   |      +----------+---+       |        |          |         |  |                          |         |  |                                              |      |     |  |                   |                |  | 
       |   |      |         \ /  |       |        +----------+         |  |                     +----|---------|--|-------------------------------------------->-+ MUX  |     |  |                   |                |  | 
       |   | EnWR2|          +   |Addr1  |                             |  |                     |    |         |  |                                              |      |     |  |                   |                |  | 
       |   +---->-+ Memory       +-<---<-+->---------------------------|--|---------------------+    |         |  |                                              |      |     |  |                   |                |  | 
       |          |              |                                     |  |                          |   +-----|--|-------------------------------------------->-+      |     |  |                   |                |  | 
       |          |              |               +--------------+      |  |                          |   |     |  |                                              |      |     |  |          +--------+------+         |  | 
       |     Size2|              |Data1     Instr|              |op    |  |                          |   |     |  |                         +-----+              |      |     |  |          |                \        |  | 
       +-------->-+              +->----------->-+ Decoder      +->----+  |                          |   +-----|--|----------------------->-+ C2T +->---------->-+      +->---|--|-------->-+  ALU            +       |  | 
                  |              |               |              |         |                          |   |     |  |                         +-----+              |      |     |  |          |                 |       |  | 
                  |              |               |              |func     |               |          |   |     |  |                                              +------+     |  |          +-------+         |       |  | 
             Addr2|              |               |              +->-------+            clk|          |   |     +--|------------+                                              |  |                  |         |res    |  | 
    +----------->-+              |               |              |             +-----------+--+       |   |     |  |            |                                              |  |                  |         +->-----+  | 
    |             |              |               |              |rs1          |          \ / |rs1D   |   |     |  +---------+  |                                            +-+--+-+                |         |       |  | 
    |             |              |               |              +->--------->-+ Register  +  +->-----|---+     |  |         |  |                      +-----+               |      |        +-------+         |       |  | 
    |        DataO|              |               |              |             | File         |       |         |  |         |  |              +--+-->-+ C2T +->------------>+ MUX  |        |                 |       |  | 
    |  +--------<-+              |               |              |rs2          |              |rs2D   |         |  |         |  |             /   |    +-----+               |      +->---->-+                 +       |  | 
    |  |          |              |               |              +->--------->-+              +->-----|---------|--|---------|--|------------+    |                          |      |        |                /        |  | 
    |  |          |              |               |              |             |              |       |      +--+--+--+      |  |            |    +------------------------>-+      |        +---------------+         |  | 
    |  |     DataI|              |               |              |rd           |              |En4W   |      | Read   |      |  |            |                               |      |                                  |  | 
    |  |  +----->-+              |               |              +->--------->-+              +-<-----|------+ or     |      |  |            |         +-----+               |      |                                  |  | 
    |  |  |       |              |               |              |             |              |       |      | Write  |      |  |            |    +-->-+ C2T +->----------->-+      |                                  |  | 
    |  |  |       |              |               |              |imm          |              |rdD    |      +--------+      |  |            |    |    +-----+               |      |                                  |  | 
    |  |  |       |              |               |              +->-----+     |              +-<-----|--+                   |  |            |    |                          |      |                                  |  | 
    |  |  |       |              |               |              |       |     |              |       |  |                   |  |            |    |       +---------------->-+      |                                  |  | 
    |  |  |       +--------------+               +--------------+       |     +--------------+       |  |                   |  |            |    |       |                  |      |                                  |  | 
    |  |  |                                                             |                            |  |                   |  |            |    |       |                  +------+                                  |  | 
    |  |  |                                                             +----------------------------+--|-------------------|--|------------|----+-------+                                                            |  | 
    |  |  |                                                                                             |                   |  |            |    |                                                                    |  | 
    |  |  +---------------------------------------------------------------------------------------------|-------------------|--|------------+    |                                                                    |  | 
    |  |                                                                                                |                   |  |                 |                                                                    |  | 
    |  |                                                                                                |                 +-+--+-+               |                                                                    |  | 
    |  |                                                                                                |                 |      |               |       +-----+                                                      |  | 
    |  |                                                                                                |                 | MUX  +-<-------------+   +---+ T2C +------------------------------------------------------+  | 
    |  |                                                                                                |                 |      |                   |   +-----+                                                      |  | 
    |  |                                                                                                |                 |      +-<-----------------+                                                                |  | 
    |  |                                                                                                |                 |      |                                                                                    |  | 
    |  |                                                                                                +-----------------+      +-<----------------------------------------------------------------------------------+  | 
    |  |                                                                                                                  |      |                                                                                    |  | 
    |  |                                                                                                                  |      +-<----------------------------------------------------------------------------------|--+ 
    |  |                                                                                                                  |      |                                                                                    |    
    |  |                                                                                                                  |      +-<-----+                                                                            |    
    |  |                                                                                                                  |      |       |                                                                            |    
    |  |                                                                                                                  +------+       |                                                                            |    
    |  |                                                                                                                                 |                                                                            |    
    |  +---------------------------------------------------------------------------------------------------------------------------------+                                                                            |    
    |                                                                                                                                                                                                                 |    
    +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+    
                                                                                                                                                                                                                          

测试代码：
```c
int buff[16];
int main(int argc, char* argv[]){
    int bias = -14;
    for (unsigned int i = 0; i < 16; ++i){
        if (i < 8) {
            buff[i] = i + (bias >> 1);
        } else {
            buff[i] = (buff[i-8] * i) << 3;
        }
    }
    return 0;
}
```
