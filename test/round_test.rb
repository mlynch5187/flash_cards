require 'minitest/autorun'
require 'minitest/pride'
require './lib/card'
require './lib/turn'
require './lib/deck'
require './lib/round'

class RoundTest < MiniTest::Test

  def setup
    @card_1 = Card.new("What is the capital of Alaska?", "Juneau", :Geography)
    @card_2 = Card.new("The Viking spacecraft sent back to Earth photographs and reports about the surface of which planet?", "Mars", :STEM)
    @card_3 = Card.new("Describe in words the exact direction that is 697.5° clockwise from due north?", "North north west", :STEM)
    @cards = [@card_1, @card_2, @card_3]
    @deck = Deck.new(@cards)
    @round = Round.new(@deck)
  end

  def test_the_deck_has_rounds
    assert_equal @deck, @round.deck
  end

  def test_rounds_have_turns
    assert_equal [], @round.turns
  end

  def test_rounds_current_card_can_be_shown
    assert_equal @card_1, @round.current_card
  end

  def test_new_turns_are_part_of_turn_class
    new_turn = @round.take_turn("Juneau")
    assert_instance_of Turn, new_turn
  end

  def test_new_turn_guess_is_correct
    new_turn = @round.take_turn("Juneau")
    assert new_turn.correct?
    wrong_turn = @round.take_turn("Venus")
    refute wrong_turn.correct?
  end

  def test_turns_are_added_to_turns_array
    new_turn = @round.take_turn("Juneau")
    assert_equal [new_turn], @round.turns
    wrong_turn = @round.take_turn("Venus")
    assert_equal [new_turn, wrong_turn], @round.turns
  end

  def test_number_correct_are_recorded
    new_turn = @round.take_turn("Juneau")
    assert_equal 1, @round.number_correct
    wrong_turn = @round.take_turn("Venus")
    assert_equal 1, @round.number_correct
  end

  def test_turn_changes_after_guess
    new_turn = @round.take_turn("Juneau")
    assert_equal Turn, new_turn.class
  end

  def test_new_turn_can_be_correct
    new_turn = @round.take_turn("Juneau")
    assert_equal true, new_turn.correct?
  end

  def test_current_card_changes
    @round.take_turn("Venus")
    assert_equal @card_2, @round.current_card
    @round.take_turn("North north west")
    assert_equal @card_3, @round.current_card
  end

  def test_number_correct_by_category_is_recorded
    @round.take_turn("Juneau")
    assert_equal 1, @round.number_correct_by_category(:Geography)
    assert_equal 0, @round.number_correct_by_category(:STEM)
  end

  def test_percent_of_cards_that_are_correct
    @round.take_turn("Juneau")
    @round.take_turn("Venus")
    assert_equal 50.0, @round.percent_correct
  end

  def test_percent_correct_by_category
    @round.take_turn("Juneau")
    @round.take_turn("Venus")
    assert_equal 100.0, @round.percent_correct_by_category(:Geography)
  end
end
