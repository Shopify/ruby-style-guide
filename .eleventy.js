const syntaxHighlight = require('@11ty/eleventy-plugin-syntaxhighlight')
require('prismjs/plugins/custom-class/prism-custom-class')
const markdownIt = require('markdown-it')
const markdownItAnchor = require('markdown-it-anchor')

module.exports = function (eleventyConfig) {
  const markdownLibrary = markdownIt().use(markdownItAnchor)
  eleventyConfig.setLibrary('md', markdownLibrary)

  eleventyConfig.addPlugin(syntaxHighlight, {
    init: function ({ Prism }) {
      Prism.plugins.customClass.prefix('prism--')
    }
  })
  eleventyConfig.setUseGitIgnore(false)
  eleventyConfig.addPassthroughCopy('CNAME')
  eleventyConfig.addPassthroughCopy({
    'node_modules/@fortawesome/fontawesome-free/webfonts': 'fonts/fontawesome'
  })
  eleventyConfig.setTemplateFormats([
    'html',
    'md',
    'njk',
    'css',
    'jpg',
    'map',
    'svg'
  ])
}
