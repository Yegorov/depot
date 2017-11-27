require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # load fixtures to test database
  fixtures :products

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "product price must be positive" do
    product = Product.new(title: "My Book title",
                          description: 'description',
                          image_url: 'zxc.jpg')
    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"],
                 product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert ["must be greater than or equal to 0.01"],
           product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(title: "My Book title",
                description: 'description',
                price: 1,
                image_url: image_url)
  end

  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
             http://a.b.c./x/y/z/fred.gif}
    bad = %w{ fred.doc fred.gif/more fred.gif.more}

    ok.each do |name|
      assert new_product(name).valid?, "#{name} shouldn't be invalid"
    end

    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end

  test "product is not valid without a unique title" do
    product = Product.new(title: products(:ruby).title,
                          description: "sdfsdf",
                          price: 1,
                          image_url: "fred.gif")
    assert product.invalid?
    assert_equal ["has already been taken"], product.errors[:title]
  end

  test "product is not valid without a unique title - i18n" do
    product = Product.new(title: products(:ruby).title,
                          description: "sdfsdf",
                          price: 1,
                          image_url: "fred.gif")
    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')],
                 product.errors[:title]
  end
end
