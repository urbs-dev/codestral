## R CMD check results

R CMD check --as-cran codestral_0.0.1.tar.gz 
Debian 10.2.1-6
R 4.4.2
Status: 2 NOTEs

R CMD check --as-cran codestral_0.0.1.tar.gz 
Windows 10 x64
R-devel (2025-05-04 r88189 ucrt)
Status: 2 NOTEs

## Following Benjamin Altman recommendations

### DESCRIPTION file

* I have added single quotes for the softwares 'Codestral' and 'Codestral Mamba' as well a 'Mistrai AI API'.
in order to stick to the Mistral AI names, other occurences of Mamba in the documentation have been 
replaced with Codestral Mamba.

* Regarding references, I have added links to the Mistral AI API documentation and to the models documentation (these are in the README too).

* I have added fields Date/URL/BugReports

### Information messages

Regarding `compile_dialog()`, the `print()` is now a `message()` and is appearing only once per function call.

In `include_file()` a `message()` has been removed as it is not very informative and partly redundant with the other `message()`.

No more print/cat in the code.

## Miscellaneous

I have clarified the documentation about both models and their API keys: the key for Codestral is specific to Codestral, the other key is a generic key for accessing Mistral AI API, giving access, in particular, to Mamba Codestral.

I have updated the README to include the description of the marker `s:` to temporarily modify the assistant behaviour.

I have included a series of unit tests for `compile_dialog()` and adjusted the function itself to handle nicely exotic behaviours.


