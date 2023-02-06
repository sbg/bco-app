app <- ShinyDriver$new("../../")
app$snapshotInit("mytest")

# Input 'bco_previewer_shinyAce_annotationTrigger' was set, but doesn't have an input binding.
app$setInputs(btn_nav_file = "click")
app$uploadFile(upfile_local_composer = "broad-best-practices-rna-seq-variant-calling.json") # <-- This should be the path to the file, relative to the app's tests/shinytest directory
app$setInputs(next_btn_local = "click")
app$setInputs(next_btn_local = "click")
app$setInputs(next_btn_local = "click")
app$snapshot()
app$snapshot()
