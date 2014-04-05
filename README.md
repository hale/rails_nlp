Rails NLP
====

Add Rails NLP to your Rails project to allow deeper full-text search across
your ActiveRecord models.

## Motivation

Users come to expect a high quality search engine, the bar is
set high by Google's intelligent use of NLP in their search engine.

Typical full-text search solutions end up relying heavily on user-input metadata
such as tags on a blog post.  

Let's say you have the following blog post:

    Improve your short-term memory with 4 scientifically proven life-hcks.

    1. Eating food rich in antioxidants, such as coriander.
    2. Playing games proven to increase short-term memory, such as n-back.
    3. Exercise! Research shows a healthy body leads to a healthy mind.
    4. Learn emergency phone numbers by heart.  This may save your life!

The following queries should match this example post, but in your typical
full text search will fail because there is no direct match between the search
terms and the text of the post:

* "benefits of eating cilantro".
* "apps to help remember things"
* "workout to improve cognition skills"
* "hacks to remember things"
* "mmemory benefits of taking antioxdants"

By adding this library to your application, you can be sure to match these
queries without resorting to tags.

* Cilantro is a North American synonym for Coriander.  Rails NLP generates
  equivalent terms from different regions.
* "remember" is a synonym of "memory".  Rails NLP matches queries against
  popular synonyms for keywords found in the text.
* RailsNLP generates word stems and phonetic representations of the words in
  your posts, so even when there are typos users still see results.
* If the search query contains words not found in the dictionary (or in the
  site), then a suggestion is offered from words that actually appear in the
  database.  This means relevant results: search suggestions will be relevant to
  your domain.

## Functionality

* A larger number of relevant search results.
* Spell-check search queries to support "Did you mean?" search suggestions.
* Search results even when users misspell or mistype keywords.
* Transparent operation; automatically updates models when changes are detected.
* Uses the textual analysis to give "related models".
* Search engine agnostic.  Each model you use with Rails NLP has its own set of
  keywords and wordcounts, leaving you free to choose an indexing service. An
  example has been included with IndexTank.
* Support for attributes through associated models (belongs\_to).
* Works with domain-specific vocabularies.  If a word is used on the site, it is
  added to the dictionary.

## Technical details

Rails NLP adds two tables to the schema: keywords and wordcounts.  This provides
models with a list of unique keywords generated from the chosen fields.  The
`text` gem is used to analyse the content, and `big huge labs` is contacted to
fetch synonyms for each keyword. Spell checking is done on the fly with
`hunspell`

The process is as follows:

1. Collect the relevant data for a model record
2. Extract relevant keywords from the text by removing stop words and non-word
   strings.
3. Count how many times each word occurs in the text to generate a list of
   wordcounts for the model.
4. Create a keyword record in the keywords table for each word in the record. A
   keyword record contains a list of synonyms, the porter stem of the word and
   its double metaphone representation.

To maintain database integrity, the process is slightly different when updating
record tracked by Rails NLP.

### Quick-start Example

1. Add 'rails\_nlp' to your Gemfile
2. Run `rake rails_nlp:init && rake db:migrate` to create and run the migrations
3. Add the following to your models:

````
    class Post
      attr_reader :title, :content, :author, :genre

      rails_nlp do
        enable :synonyms, :meatphones
        analyse(:title, 'genre.name', :content
      end
    end
````

4. Generate the initial set of data with: `rake rails_nlp:analyse`
