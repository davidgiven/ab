The good/bad tests are generally a bad idea; a Python quirk causes parent
modules to be sometimes loaded with child modules, which means that in the test
environment the result contains way more than it should. But this only shows up
in the test environment.