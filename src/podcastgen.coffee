json2xml = require 'json2xml'
url = require 'url'

escapeSpecialChars = (text) ->
  text
    .replace /&/g, "&amp;"
    .replace /</g, "&lt;"
    .replace />/g, "&gt;"
    .replace /"/g, "&quot;"
    .replace /'/g, "&#039;"

module.exports = (opts) ->
  feed = {
    attr: {
      "xmlns:itunes":"http://www.itunes.com/dtds/podcast-1.0.dtd",
      "version":"2.0",
      "xmlns:atom":"http://www.w3.org/2005/Atom",
      "xmlns:media":"http://search.yahoo.com/mrss/"
    },
    rss: {
      channel: [
        {"atom:link":'', attr: { href: escapeSpecialChars opts.podcastUrl, rel: "self", type: "application/xml" }},
        {title: opts.title},
      ].concat opts.items.map (item) ->
        itemUrl = escapeSpecialChars url.resolve((opts.baseUrl||''), item.path)
        {
          item: [
            {title: item.title},
            {'media:content':'', attr: { url: itemUrl, type:"audio/mpeg", medium:"audio", expression:"full" }},
            {enclosure:'', attr: { url: itemUrl, type: "audio/mpeg" }},
            {pubDate: item.date},
            {guid: itemUrl, attr: {isPermaLink:"true"}},
          ]
        }
    }
  }

  json2xml feed, { header: true, attributes_key: 'attr' }

