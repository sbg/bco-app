app <- ShinyDriver$new("../../")
app$snapshotInit("mytest")

app$setInputs(bco_previewer_shinyAce_annotationTrigger = 0.601968089275984, allowInputNoBinding_ = TRUE)
app$setInputs(btn_nav_file = "click")
app$uploadFile(upfile_local_composer = "DE_plus_Salmon.json") # <-- This should be the path to the file, relative to the app's tests/shinytest directory
app$snapshot()
