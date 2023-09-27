from build.ab2 import simplerule, filenamesof

simplerule(name="r1", ins=[], outs=["out1"])
simplerule(name="r2", ins=[], outs=["out2"])
simplerule(name="all", ins=["+r1", "+r2"], outs=["outa"])
