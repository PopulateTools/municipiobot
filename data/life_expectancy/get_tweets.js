var fs = require('fs');
var d3 = require('d3');

fs.readFile('output/data.csv', 'utf8', function(error, data) {
  data = d3.csvParse(data);
  
  // String parsers  
  function getGender(d) {
    return d === 'Hombre' ? 'un hombre' : 'una mujer';
  }
  
  // Get a random message from the array
  function getMessage(d) {
    var strings = [
      `A ${getGender(d.gender)} de ${d.district} de ${d.age.toLowerCase()} le quedan ${d.life_exp.slice(0, 2)} años`
    ];
    
    return strings[Math.floor(d3.randomUniform(0, strings.length)())];
  }
  
  // Return the tweet
  data.forEach(function(d) {
    d.string = getMessage(d);
  });
  
  // Store only the tweet
  var result = d3.csvFormatRows(data.map(function(d, i) {
    return [
      d.string
    ];
  }));
  
  fs.writeFile('output/tweet_list.txt', result, function(err) {
    console.log('Life expectancy tweets written 🚀');
  });
});
