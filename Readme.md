Enigma
=======

Enigma is an encryption engine for encrypting, decrypting, and cracking
messages, loosely based on the encryption algorithm used by the Enigma Machine during WWII. The project requires only Ruby.

Testing
-------
Testing is setup to use Minitest, rspec and mrspec. I recommend testing with mrspec. To do so, simply run 'mrspec' in the project root directory after downloading the mrspec gem.

Method Descriptions:
--------------------

###Class: ENIGMA
####Enigma.initialize:
Initializes the instance variable @set, which is the set of characters that will be understood and used in the encryption.

If you would like to add or remove characters, be sure to change the total number of characters used in Enigma.third_encryption, accordingly.

####Enigma.encrypt:
This method takes the following three arguments: a string message that needs to be encrypted, a five digit numeric encryption key, and a date as an integer formatted as %m%d%y.  Outside of the purposes of testing, the default values for .encrypt will suffice as they load a message from a file named "message.txt", generate a random key, and generate a date.

Enigma.encrypt proceeds to call a series of methods that rely on each other's outputs in order to encrypt the message.

####Enigma.key_encrypt:
This method is indirectly called by Enigma.encrypt and takes the key passed into Enigma.encrypt as its argument. Enigma.key_encrypt translates the key into an array defined as key_offset.  Key_offset can be understood in the following example: Key = 38274; Key Offset = [38,82,27,74].

####Enigma.date_encrypt:
This method is indirectly called by Enigma.encrypt and takes the date passed into Enigma.encrypt as its argument. Enigma.date_encrypt translates the date into an array defined as date_offset. Date_offset can be understood in the following example: Date = 121015; Date ** 2 == 14644630225; the last four digits of Date ** 2 == 0225; date_offset = [0,2,2,5].

####Enigma.rotation_engine:
This is the first method called directly by Enigma.encrypt, which in turn takes the two methods described above (key_encrypt and date_encrypt) as arguments. Enigma.rotation_engine defines rotation_array as the sum of the corresponding indices of key_offset and date_offset. This is array will used to define how to rotate individual characters in a message as it is being encrypted.

####Enigma.first_encryption:
This method is the second method called by Enigma.encrypt and serves as the instruction for translating a message's characters into their corresponding indices of @set. Example: "Hi" => [7, 8]

####Enigma.rotate:
This method is called by Enigma.encrypt after .first_encryption is called and takes the output of .first_encryption and the output of .rotation_engine (i.e. rotation_array) as its arguments. Enigma.rotate takes the first encryption and translates it into four arrays: a, b, c and d.  These arrays are populated by every fourth character in the message being encrypted and then each of those characters is added to a corresponding value in rotation_array, where a is mapped to rotation_array[0], b is mapped to rotation_array[1], is mapped to rotation_array[2], is mapped to rotation_array[3].  
#####Example:
[1, 2, 3, 4, 1, 2, 3, 4].rotate => a=[1 + rotation_array[0], 1 + rotation_array[0]], b=[2 + rotation_array[1], 2 + rotation_array[1]], @c=[3 + rotation_array[2], 3 + rotation_array[2]], @d=[4 + rotation_array[3], 4 + rotation_array[3]]

Enigma.rotate returns the array rotated_message, which is equal to the multi-dimensional array [a, b, c, d].  Using the example above, rotated_message would be equal to:
[[1 + rotation_array[0], 1 + rotation_array[0]], [2 + rotation_array[1], 2 + rotation_array[1]], [3 + rotation_array[2], 3 + rotation_array[2]], [4 + rotation_array[3], 4 + rotation_array[3]]]

####Enigma.second_encryption:
This method is called by Enigma.encrypt after .rotate is called and takes the output of .rotate (rotated_message) as it argument. The purpose of this method is to put all of the rotated characters of the message back in the correct order. It achieves this in an interesting way using Ruby Enumerable's .each_with_index method.  First, .second_encryption iterates over rotated_message[0] and shovels its elements into the empty array encrypt_ii.  Next, it defines a new array, first, that maps with indices over encrypt_ii. Then, it defines a new array, second, that maps with indices over first. Once more, it defines a new array, third, that maps with indices over second.  At this point, encrypt_ii is redefined as third.flatten.compact, which outputs the rotated characters of the original message in the correct order.
#####Example:
message = "Readme"
date_offset = [0, 2, 2, 5]
key_offset = [83, 39, 94, 48]
encrypt_i = [17, 4, 0, 3, 12, 4]
rotation_array = [83, 41, 96, 53]
rotated_message = [[100, 95], [45, 45], [96], [56]]

second_encryption(rotated_message)
  rotated_message[0].each do |x|
    encrypt_ii << x
  end
  => encrypt_ii == [100,95]

  first = encrypt_ii.each_with_index.map do |x, i|
    `[x,rotated_message[1][i]]`
  end
  => [[100, 45], [95, 45]]

  Here we see what is happening in this method: when we iterate over encrypt_ii with .each_with_index |x,i|, and pass in rotated_message`[1][i]`, instead of passing in a number for the index, it passes in the same index of the rotated_message array. Repeating this process eventually puts all the elements of the original message back in the correct order we are left with a multi-dimensional array that we just have to .flatten to create one dimension, and .compact in order to get rid of any nils that were added to the array due to differences in the sizes of the arrays inside of rotated_message.

  ####Enigma.third_encryption:
  This method is called by Enigma.encrypt after .second_encryption and takes the output of .second_encryption (encrypt_ii) as its argument. The purpose of this method is to reduce the values of each element in encrypt_ii to values that can be mapped to `@set`. Enigma.third_encryption simply outputs a new array that has changed only the elements that are greater than the total number of characters in `@set`. If an element in encrypt_ii is greater that the total number of characters in `@set`, that element is changed to the remainder of that element/@set.length.

  Enigma.fourth_encryption: This method is called by Enigma.encrypt after .third_encryption and takes the output of .third_encryption (encrypt_iii) as its argument. The purpose of this method is to translate encrypt_iii to the actual characters in `@set`, by mapping to `@set's` indices. Enigma.fourth_encryption  then formats the encrypted message into a string and outputs the encryption to the screen and to the file 'encrypted_message.txt'.
