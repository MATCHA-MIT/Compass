
config cfg;
    design get_design_info;
    instance get_design_info.uArchOriginal liblist uArchOriginalLib;
    instance get_design_info.uArchTaint    liblist uArchTaintLib;
    instance get_design_info.ISATaint      liblist ISATaintLib;
endconfig


module get_design_info(
  input clk,
  input rst
);

  SodorInternalTile uArchOriginal(.clock(clk), .reset(rst));
  SodorInternalTile uArchTaint   (.clock(clk), .reset(rst));
  ISATaint          ISATaint     (.clock(clk), .reset(rst));

endmodule

