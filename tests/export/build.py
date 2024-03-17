from build.ab import simplerule, export

ra = simplerule(name="r1", ins=[], outs=["out1"])
rb = simplerule(name="r2", ins=[], outs=["out2"])
re = simplerule(name="re", ins=[".+r1", ".+r2"], outs=["outa"])

export(name="all", items={"r1": ".+r1", "r2": ".+r2"})
