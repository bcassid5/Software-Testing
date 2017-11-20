module.exports = function(config) {
  config.set({
    basePath: '',
    frameworks: ['jasmine', 'requirejs'],

    files: [
      'test-main.js',
      {pattern: '*.coffee', included: false},
      'purchaseOrder.js'
    ],
    exclude: [],
    preprocessors: {
      '**/*.coffee': ['coffee'],
      'purchaseOrder.js': ['coverage']
    },
    coverageReporter: {
      type : 'text',
      dir : 'coverage/',
      file : 'testing.txt',
      instrumenterOptions: {
        istanbul: { noCompact: true }
      }
    },
    reporters: ['mocha', 'coverage'],
    port: 9876,
    colors: true,
    logLevel: config.LOG_INFO,
    autoWatch: true,
    browsers: ['Chrome'],
    singleRun: true,
    concurrency: Infinity
  });
}
