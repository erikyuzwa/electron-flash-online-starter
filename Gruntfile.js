

module.exports = function(grunt) {

    var cmdFlashArgs = [
        '-use-network=true',
        '-headless-server=true',
        '-debug=false',
        '-static-link-runtime-shared-libraries=true'
    ];

    grunt.initConfig({
        copy: {
            build: {
                files: [
                    // includes files within path and its sub-directories
                    {expand: true, cwd: 'client/', src: ['**', '!src/**', '!styles/*.scss'], dest: 'build/'}
                ],
            },

        },
        babel: {
            build: {
                options: {
                    sourceMap: true,
                    presets: ['es2015']
                },
                files: {
                    'build/bundle.js': './client/src/js/app.js'
                }
            }
        },
        mxmlc: {
            options: {
                rawConfig: cmdFlashArgs.join(' ')
            },
            build: {
                files: {
                 'build/example.swf': ['client/src/as/Main.as']
                }
            }
        },
        jshint: {
            files: ['client/src/js/**/*.js'],
            options: {
                globals: {
                    jQuery: true
                }
            }
        },
        watch: {
            files: ['<%= jshint.files %>'],
            tasks: ['jshint']
        },
        sass: {
            build: {
                options: {
                    style: 'expanded'
                },
                files: {
                    'client/styles/app.css': 'client/styles/app.scss',
                }
            }
        },
        uglify: {
            options: {
                mangle: false
            },
            build: {
                files: {
                    'build/bundle.min.js': ['<%= jshint.files %>']
                }
            }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-jshint');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-mxmlc');
    grunt.loadNpmTasks('grunt-contrib-sass');
    grunt.loadNpmTasks('grunt-babel');
    grunt.loadNpmTasks('grunt-contrib-copy');

    grunt.registerTask('default', ['jshint', 'sass:build', 'uglify', 'mxmlc:build', 'copy:build']);

};
