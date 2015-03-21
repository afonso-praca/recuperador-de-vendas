module.exports = (grunt) ->
  pkg = grunt.file.readJSON('package.json')

  coffeeFiles = ['config/**/*.coffee', 'libs/**/*.coffee', 'services/**/*.coffee']

  grunt.initConfig
    watch:
      coffee:
        files: coffeeFiles
        tasks: ['coffee']


  # Registering tasks
  tasks =
    build: ['test']
    default: ['testWatch']
    test: []
    testWatch: ['test', 'watch']
  
  grunt.registerTask taskName, taskArray for taskName, taskArray of tasks

  # Load NPM tasks
  grunt.loadNpmTasks name for name of pkg.devDependencies when name[0..5] is 'grunt-'

