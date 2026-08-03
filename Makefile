.PHONY: jg_batch jg_gui clean

# Run JasperGold in batch mode (prints results to terminal)
jg_batch:
	jaspergold -batch run_jg.tcl

# Run JasperGold in GUI mode
jg_gui:
	jaspergold -tcl run_jg.tcl &

# Clean up generated files
clean:
	rm -rf jgproject *.log
