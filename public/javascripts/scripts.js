function updateHangmanHTML(new_word_display, tries_remaining){
  $hangmanWord = $($(".hangman-word-display")[0]);
  $hangmanTries = $($(".hangman-tries-display")[0]);
  $hangmanWord.text(new_word_display);
  $hangmanTries.text(("Tries remaining: " + tries_remaining));
  $(".hangman-guess").val('');
}

function hangmanGameOver(win_boolean){

}


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
        updateHangmanHTML(data.new_display, data.tries);
      }
    });

  }); // end of guess function


});