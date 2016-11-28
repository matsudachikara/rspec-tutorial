require 'rails_helper'

describe Contact do
  # 姓と名とメールがあれば有効な状態であること
  it "is valid with a firstname, lastname and email" do
    contact = Contact.new(
      firstname: 'Aaron',
      lastname: 'Sumner',
      email: 'tester@example.com'
    )
    expect(contact).to be_valid
  end
  # 名がなければ無効な状態であること
  it "is invalid without a firstname" do
    contact = Contact.new(firstname: nil)
    contact.valid?
    expect(contact.errors[:firstname]).to include("can't be blank")
  end
  # 姓がなければ無効な状態であること
  it "is invalid without a lastname" do
    contact = Contact.new(lastname: nil)
    contact.valid?
    expect(contact.errors[:lastname]).to include("can't be blank")
  end
  # メールアドレスがなければ無効な状態であること
  it "is invalid without an email address" do
  end
  # 重複したメールアドレスなら無効な状態であること
  it "is invalid with a duplicate email address" do
    Contact.create(
        firstname: 'Joe', lastname: 'Tester',
        email: 'tester@example.com'
    )
    contact = Contact.create(
        firstname: 'Jane', lastname: 'Tester',
        email: 'tester@example.com'
    )
    contact.valid?
    expect(contact.errors[:email]).to include("has already been taken")
  end
  # 連絡先のフルネームを文字列として返すこと
  it "returns a contact's full name as a string" do
    contact = Contact.new(firstname: 'John', lastname: 'Doe', email: 'johndoe@example.com')
    expect(contact.name).to eq 'John Doe'
  end

  describe "filter last name by letter" do
    before :each do
      @smith = Contact.create(
          firstname: 'John',
          lastname: 'Smith',
          email: 'jsmith@example.com'
      )
      @jones = Contact.create(
          firstname: 'Tim',
          lastname: 'Jones',
          email: 'tjones@example.com'
      )
      @johnson = Contact.create(
          firstname: 'John',
          lastname: 'Johnson',
          email: 'jjohnson@example.com'
      )
    end

    context "matching letters" do
      it "returns a sorted array of results that match" do
        expect(Contact.by_letter("j")).to eq [@johnson, @jones]
      end
    end

    context "non-matching leters" do
      it "omits results that do not match" do
        expect(Contact.by_letter("j")).not_to include @smith
      end
    end

  end
end