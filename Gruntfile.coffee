module.exports = (grunt) ->
  pkg = grunt.file.readJSON('package.json')
  coffeelintConfig = grunt.file.readJSON('coffeelint-config.json')

  coffeeFiles = ['config/**/*.coffee', 'libs/**/*.coffee', 'services/**/*.coffee', 'test/**/*.coffee']

  grunt.initConfig

    coffeelint:
      main:
        files:
          src: coffeeFiles
      options: coffeelintConfig

    watch:
      main:
        files: coffeeFiles
        tasks: ['coffeelint', 'mochaTest']

    mochaTest:
      main:
        options:
          reporter: 'nyan'
          require: 'coffee-script/register'
        src: ['test/**/*-test.coffee']


  # Registering tasks
  tasks =
    build: ['test']
    default: ['testWatch']
    test: ['coffeelint', 'mochaTest']
    testWatch: ['test', 'watch']
  
  grunt.registerTask taskName, taskArray for taskName, taskArray of tasks

  # Load NPM tasks
  grunt.loadNpmTasks name for name of pkg.devDependencies when name[0..5] is 'grunt-'

