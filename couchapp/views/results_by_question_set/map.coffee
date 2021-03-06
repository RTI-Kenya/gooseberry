(doc) ->
  if doc.from and doc.results[0]
    data = {
      complete: doc.complete
    }
    startTime = doc.results[0].datetime
    for result in doc.results
      if (result.valid)
        data[result.question_index] = result.answer
    if doc.other_data
      for property,value of doc.other_data
        data[property] = value
    #include metadata at the end of the array
    data["from"] = doc.from
    data["updated_at"] = doc.updated_at
    #emit doc.question_set, data
    emit [doc.question_set,startTime], data
