
$(function(){
  console.log("Hey there stud ;)")

  // guess functionality
  $(".hangman-submit").on('click', function(e){
    e.preventDefault();
    var guessedLetter = $(".hangman-guess").val().toLowerCase();
    $.ajax({
      url: $(".hangman-form").attr("action"),
      method: 'POST',
      dataType: "json",
      data: {
        guess: guessedLetter,
      },
      success: function(data) {
        console.log(data);
      }
    });

  }); // end of guess function


});