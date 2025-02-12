# codestral

Use codestral API for fill in the middle (FIM) in Rstudio.

# Initialization

You should first have an API key from the Mistral AI Plateforme.

After package is installed, load it with `library(codestral)`.

To be able to use the addin, you should run once `codestral_init()` function
with proper parameters (see the documentation).

After that, you are good to go.

# Using codestral package

## Default usage

To use the addin, position your cursor at the place you want the FIM to appear 
and look for `Codestral code completion` in the Addins list of RStudio.

When you click on the addin, the codestral answer is inserted. The prompt is 
the part of the script before the cursor, the suffix is the part of the script 
afteer the cursor.

## Keyboard shortcut

In order to define a keyboard shortcut for this addin, in Rstudio, choose the 
menu Tools/Addins/Brows Addins... In the pop-up window, click on the Keyboard shortcuts button.
in the new window, double click on the table's cell at row "Codestral code completion" and 
column "Shortcut". Insert your shortcut.

You can now replace default usage by your shortcut.

