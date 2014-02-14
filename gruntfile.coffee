module.exports = (grunt)->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    coffee:
      app:
        files: [
          src: 'src/index.coffee'
          dest: 'app/index.js' ]
      test:
        files: [
          src: 'spec/factory-b-spec.coffee'
          dest: 'test/factory-b-spec.js' ]
    coffeelint:
      app: ['src/index.coffee']
      test: ['spec/spec.coffee']
      grunt: ['gruntfile.coffee']
    clean: ["app"]
    watch:
      server:
        files: ['src/*/*.coffee', 'src/*.coffee', 'src/*/*/*.coffee', 'spec/*.coffee', 'spec/*/*.coffee'],
        tasks: ['coffeelint:test', 'coffeelint:app', 'spec']

  
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-jasmine-bundle'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-notify'
  grunt.loadNpmTasks 'grunt-release'
  grunt.registerTask 'lint', ['coffeelint']
  grunt.registerTask 'test', ['spec']
  grunt.registerTask 'build', ['coffee:app']
  grunt.registerTask 'default', ['coffeelint:app', 'test', 'clean', 'build']
  grunt.registerTask 'patch', ['default', 'release:patch']
  grunt.registerTask 'minor', ['default', 'release:minor']
  grunt.registerTask 'major', ['default', 'release:major']