# icePie FPGA devkit - Workshop Example Codes

Examples codes from icePie FPGA devkit workshop 

## Requirements: 

* [apio](https://github.com/FPGAwars/apio)
	```bash
	pip install apio@git+https://github.com/bitsynaptics/apio
	apio install --all
	apio drivers --ftdi-enable
	```

* For Windows users, follow the [Windows Toolchain Install Guide](docs/icePie%20FPGA%20devkit%20-%20Windows%20Toolchain%20Install%20Guide.pdf)
  
## Install:

  * Download all the workshop example codes
  ```bash
   git clone https://github.com/bitsynaptics/icePie-workshop-codes
   ```

  
  * Use `apio build` and `apio upload` in example directories with `apio.ini` file. `apio clean` for clearing build files. 
 

## Licenses

Applicable license is individual to each IP core / project and is mentioned
in the IP core / example directory itself and in each file.
