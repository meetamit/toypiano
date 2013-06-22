module.exports = (grunt) ->
  DEV_BUILD = "build/development"
  grunt.initConfig
    clean:
      development: "#{DEV_BUILD}"
    
    copy:
      development:
        files: [
          { expand: true, cwd: "app/public", src:['**'], dest: "#{DEV_BUILD}" }
        ]
    
    coffee:
      development:
        options:
          sourceMap: true
        files: [
          expand: true
          cwd: "app/coffee"
          dest: "#{DEV_BUILD}/js"
          src: ["*.coffee", "**/*.coffee"]
          ext: ".js"
        ]
    
    jade:
      development:
        files: [
          src: "app/jade/index.jade"
          dest: "#{DEV_BUILD}/index.html"
        ]
      ios:
        files: [
          src: "app/jade/ios.jade"
          dest: "#{DEV_BUILD}/index.html"
        ]
        # files: [
        #   expand: true
        #   cwd: "app/jade"
        #   dest: "#{DEV_BUILD}"
        #   src: ["*.jade"]
        #   ext: ".html"
        # ]

    sass:
      development:
        files: [
          src: "app/sass/main.scss"
          dest: "#{DEV_BUILD}/css/main.css"
        ]
    
    connect:
      server:
        options:
          hostname: ''
          port: 3000
          base: "./#{DEV_BUILD}"
          middleware: (connect, options) -> [
            connect.compress()
            connect.static(DEV_BUILD),
          ]

    watch:
      coffee:
        files: ["app/coffee/*.coffee", "app/coffee/**/*.coffee"]
        tasks: 'coffee:development'

      sass:
        files: ["app/sass/*.scss"]
        tasks: ['sass:development']

      templates:
        files: ["app/templates/*.jade"]
        tasks: 'templates'
      
      jade:
        files: ["app/jade/*.jade"]
        tasks: 'jade:development'
      
      img:
        files: ["app/public/img/*", "app/public/img/**/*"]
        tasks: 'copy'
    
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  
  grunt.registerTask 'templates', 'Compile and concatenate Jade templates for client.', -> 
    fs = require 'fs'
    jade = require 'jade'
    
    tmplFileContents = "define(['jade'], function(jade) {\n"
    tmplFileContents += 'window.JST = {};\n'
    
    for filename in fs.readdirSync "app/templates"
      path = "app/templates/#{filename}"
      contents = jade.compile(
        fs.readFileSync(path, 'utf8'), { client: true, compileDebug: false, filename: path }
      ).toString()
      tmplFileContents += "JST['#{filename.split('.')[0]}'] = #{contents};\n"
    
    tmplFileContents += 'return JST;\n'
    tmplFileContents += '});\n'
    fs.writeFileSync "#{DEV_BUILD}/js/templates.js", tmplFileContents
  
  grunt.registerTask 'build:base', [
    'clean'
    'copy'
    'coffee'
    'sass'
    'templates'
  ]

  grunt.registerTask 'ios', [
    'build:base'
    'jade:ios'
  ]
  
  grunt.registerTask 'default', [
    'build:base'
    'jade:development'
    'connect'
    'watch'
  ]
