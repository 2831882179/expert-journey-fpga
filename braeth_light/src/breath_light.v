/*
Module Nmae:breath_light
Input clk;
Output [2,0]led;

clk    = H11
led[0] = C13
led[1] = N16
led[2] = L14

*/
module breath_light(
  input clk, 
  output reg [2:0]led
);

// 配置寄存器
reg [9:0] cnt_s;
reg [9:0] cnt_ms;
reg [4:0] cnt_us;
reg a;

// 初始化计时器
parameter T_s = 10'd999; // 设置10位1000个单位的参数用于表示1S；
parameter T_ms = 10'd999; 
parameter T_us = 5'd23; 

initial 
 begin 
  a <= 1'b0; // 在初始时刻，将 a 的值赋为二进制数 0
  led <= 3'b000; // 在初始时刻，将 led 的值赋为二进制数 000，表示三个 led 灯都熄灭
  cnt_s <= 10'd0; // 在初始时刻，将 cnt_s 的值赋为十进制数 0
  cnt_ms <= 10'd0; // 在初始时刻，将 cnt_ms 的值赋为十进制数 0
  cnt_us <= 5'd0; // 在初始时刻，将 cnt_us 的值赋为十进制数 0
 end
//微秒计时器
always @ (posedge clk)// 在时钟信号 clk 的上升沿触发以下语句
begin
  if(cnt_us == T_us)
    cnt_us <= 5'd0;
  else
    cnt_us <= cnt_us +5'd1;
end
//毫秒计时器
always @ (posedge clk )
begin
  if(cnt_us == T_us && cnt_ms == T_ms)
    cnt_ms <= 10'd0;
  else if(cnt_us == T_us)
    cnt_ms <= cnt_ms + 10'd1;
end
//秒计时器
always @ (posedge clk)
begin
  if(cnt_us == T_us && cnt_ms == T_ms && cnt_s == T_s)
    cnt_s <= 10'd0;
  else if(cnt_us == T_us && cnt_ms == T_ms)
    cnt_s <= cnt_s + 10'd1;
end

// 标志位
always @ (posedge clk)
begin
  if(cnt_us == T_us && cnt_ms == T_ms && cnt_s == T_s)// 如果微秒计数器的值等于微秒计数器的最大值，并且毫秒计数器的值等于毫秒计数器的最大值，并且秒计数器的值等于秒计数器的最大值
    a <= ~a;//标志位取反
  else
    a <= a;
end

always @ (posedge clk ) // 在时钟信号 clk 的上升沿触发以下语句
begin
  if(cnt_s > cnt_ms && a ==1'b1) // 如果秒计数器的值大于毫秒计数器的值，并且标志位 a 的值为 1，表示呼吸灯由暗到亮
    led <= 3'b111; // 则将 led 的值赋为二进制数 111，表示三个 led 灯都点亮
  else if(cnt_s < cnt_ms && a ==1'b1) // 否则如果秒计数器的值小于毫秒计数器的值，并且标志位 a 的值为 1，表示呼吸灯由亮到暗
    led <= 3'b000; // 则将 led 的值赋为二进制数 000，表示三个 led 灯都熄灭
  
   else if(cnt_s > cnt_ms && a ==1'b0) // 否则如果秒计数器的值大于毫秒计数器的值，并且标志位 a 的值为 0，表示呼吸灯由亮到暗
    led <= 3'b000; // 则将 led 的值赋为二进制数 000，表示三个 led 灯都熄灭
   else if(cnt_s < cnt_ms && a ==1'b0) // 否则如果秒计数器的值小于毫秒计数器的值，并且标志位 a 的值为 0，表示呼吸灯由暗到亮
    led <= 3'b111; // 则将 led 的值赋为二进制数 111，表示三个 led 灯都点亮 
end

endmodule
