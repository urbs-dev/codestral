# codestral

Use codestral API for fill in the middle (FIM) and basic chat in Rstudio.
This package creates an Addin in Rstudio that allows a direct and simple use of the Mistral AI APIs.

# Initialization

You should first have an API key from the Mistral AI Plateforme.

After package is installed, load it with `library(codestral)`.

To be able to use the addin, you should run once `codestral_init()` function
with proper parameters (see the documentation).

After that, you are good to go.

# Using codestral package

## Fill in the middle (FIM)

To use the addin, position your cursor at the place you want the FIM to appear 
and look for `Codestral code completion` in the `Addins` list of `RStudio`.

When you click on the addin, the codestral answer is inserted. In the request, the prompt is 
the part of the script before the cursor, the suffix is the part of the script 
after the cursor. The answer is limited to `max_tokens` as set in `codestral_init`. In case you feel the FIM is incomplete, just activate the Addin again.

## Chat

- To prompt the Codestral completion functionlity

The current script should start with `c:`. Position your cursor at the end of your question. Activate the addin as for FIM. The answer is inserted from your cursor position.

- To prompt the Mamba completion functionality

Just replace `c:` with `m:`.

The answer will start with `a:`.

You can continue the conversation starting a new line with `c:` or `m:`.

Or you can regenerate a new answer just re-activating the Addin.

## Including files

If you wish to include a text file (.R, .Rmd ...) in your prompt, just make sure that the file is in the current working directory or one of its subdirectories and add a line in your prompt starting by "ff:" and followed by the file name :

"ff:my_file.R"

This will trigger the insertion of the content of `my_file.R` where the instruction has been placed

## Faster using keyboard shortcut

In order to define a keyboard shortcut for this addin, in Rstudio, choose the 
menu Tools/Addins/Brows Addins... In the pop-up window, click on the Keyboard shortcuts button.
in the new window, double click on the table's cell at row "Codestral code completion" and 
column "Shortcut". Insert your shortcut.

You can now replace default usage by your shortcut.

