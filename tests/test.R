app <- ShinyDriver$new("..")
app$snapshotInit("test")

app$snapshot()
app$setInputs(fc2 = 1)
app$snapshot()
app$setInputs(fc2 = 10)
app$snapshot()
