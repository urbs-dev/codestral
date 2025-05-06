## R CMD check results

0 errors | 0 warnings | 1 note

## Following Benjamin Altman recommendations

DESCRIPTION file: 
* I have added single quoted for the softwares 'Codestral' and 'Codestral Mamba' as well a 'Mistrai AI API'.
in order to stick to the Mistral AI names, other occurences of Mamba in the doc have been 
replaced with Codestral Mamba.
* Regarding references, I have added links to the Mistral AI API documentation and to the models documentation (these are in the README too).

## Information messages

Regarding `compile_dialog()`, the `print()` is now a `message()` and is appearing only once per function call.

In `include_file()` a `message()` has been removed as it is not very informative and partly redundant with the other `message()`.

No more print/cat in the code.

## Miscellaneous

I have clarified the documentation about both models and their API keys: the key for Codestral is specific to Codestral, the other key is a generic key for accessing Mistral AI API, giving access, in particular, to Mamba Codestral.

I have updated the README to include the description of the marker `s:` to temporarily modify the assistant behaviour.

I have included a series of unit tests for `compile_dialog()`. 
