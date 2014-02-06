# basic gulpfile to build libraries with CoffeeScript and CommonJS
gulp = require( 'gulp' )
gutil = require( 'gulp-util' )
coffee = require( 'gulp-coffee' )
coffeelint = require( 'gulp-coffeelint' )
define = require( 'gulp-wrap-define' )
concat = require( 'gulp-concat' )
rename = require( 'gulp-rename' )
uglify = require( 'gulp-uglify' )



# concatenates and builds files
build = ( name ) ->
	gutil.combine(
		concat( "#{name}.js" )
		gulp.dest( './dist' )
		rename( "#{name}.min.js" )
		uglify( )
		gulp.dest( './dist' )
	)( )



# default task
gulp.task( 'default', [ 'vendors', 'lib' ])



# watches changes in source files
gulp.task( 'watch', ( ) ->
	gulp.watch( './lib/*', [ 'lib' ])
)



# builds vendors files
gulp.task( 'vendors', ( ) ->
	gulp
		.src([
			'./bower_components/commonjs-require-definition/require.js'
			'./bower_components/lodash/dist/lodash.js'
			'./bower_components/jquery/jquery.js'
			'./vendors/*'
		])
		.pipe( define(
			root: './lib'
			define: 'require.register'
		))
		.pipe( build( 'vendors' ))
)



# builds library files
gulp.task( 'lib', ( ) ->
	gulp
		.src( './lib/*.coffee' )
		.pipe( coffeelint(
			# if you like tabs and you know it
			# indentation:
			#	value: 1
			# no_tabs:
			#	level: ignore
		))
		.pipe( coffeelint.reporter( ))
		.pipe( coffee(
			bare: true
		))
		.on( 'error', gutil.log )
		.pipe( define(
			root: './lib'
			define: 'require.register'
		))
		.pipe( build( 'lib' ))
)
