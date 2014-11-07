$hangmanContainer = null;
$hangmanWord = null;
$hangmanTries = null;
$hangmanForm = null;

function setHangmanConstants(){
  $hangmanContainer = $($('.hangman-container')[0]);
  $hangmanWord = $($(".hangman-word-display")[0]);
  $hangmanTries = $($(".hangman-tries-display")[0]);
  $hangmanForm = $($(".hangman-form")[0]);
}



function updateHangmanHTML(new_word_display, tries_remaining){
  $hangmanWord.text(new_word_display);
  $hangmanTries.text(("Tries remaining: " + tries_remaining));
  $(".hangman-guess").val('');
}

function updateHangmanImg(tries_remaining){
  $hangmanImg = $($('.hangman-img')[0]);
  var new_src = ("/images/hangman/hangman_" + tries_remaining + ".png");
  $hangmanImg.attr('src', new_src);
}

function hangmanGameOver(win_boolean){
  $hangmanTries.remove();
  $hangmanForm.remove();
  if (win_boolean){
    $gameResultMessage = $('<h2>').text("You win!!!");
  } else {
    $gameResultMessage = $('<h2>').text("You lose dummy!!!");
  }
  $hangmanContainer.append($gameResultMessage);
  buildGameResultNavbar();
}

function buildGameResultNavbar(){
  $gameResultUl = $("<ul>").attr("class", "game-result-navbar");
  //new game 'button'
  $newGameLi = $("<li>");
  $newGameAnchor = $("<a>").attr('href', "/hangman").text("New Game");
  //back to all gamez 'button'
  $gamezLi = $("<li>");
  $gamezAnchor = $("<a>").attr('href', "/games").text("Play a different game");
  //put it all together...
  $gameResultUl.append($newGameLi.append($newGameAnchor));
  $gameResultUl.append($gamezLi.append($gamezAnchor));
  $hangmanContainer.append($gameResultUl);
}


$(function(){
  console.log("Hey there stud ;)");
  setHangmanConstants();

  // guess functionality for hangman
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
        updateHangmanHTML(data.new_display, data.tries);
        updateHangmanImg(data.tries);
        if (data.game_completed) {
          hangmanGameOver(data.win);
        }
      }
    });
  }); // end of guess function


});