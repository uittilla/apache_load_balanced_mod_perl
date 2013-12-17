$(function () {
      $('#msg').focus();

      var log = function (text) {
        $('#log').val( $('#log').val() + text + "\n");
      };
  
      var ws = new WebSocket('ws://perl-simple-web-mvc.co.uk:3000/socket/');
      ws.onopen = function () {
        log('Connection opened');
      };
  
      ws.onmessage = function (msg) {
        var res = JSON.parse(msg.data);
        log('[' + res.hms + '] ' + res.text); 
      };

    $('#msg').keydown(function (e) {
        if (e.keyCode == 13 && $('#msg').val()) {
            ws.send($('#msg').val());
            $('#msg').val('');
        }
      });
});