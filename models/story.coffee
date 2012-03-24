storySchema = new mongoose.Schema({
  id: Number
  ratings: {}
})
storySchema.statics.rate = (token, story, rating, cb) ->
  Story.find {id: story}, (e, sts) ->
    st = null
    if sts.length > 0
      st = sts[0]
    else
      st = new Story()

    st.id = story
    st.ratings = {} unless st.ratings
    st.ratings[token] = rating
    st.save (e) ->
      cb(e)

global.Story = mongoose.model('Story', storySchema)
