#!/usr/bin/perl

use strict;
use FriendsterMobileProfileBrowser;
use File::Find;

use vars qw(
	$crawler
	$email
	$password
	$dir
	$wget_add_media
	@hobby @book @genre @show @about @meet @firstname @secondname @middlename @lastname @photo @movie
	$hobby $book $genre $show $about $meet $firstname $secondname $middlename $lastname $photo $movie
	$wget_edit_profile
	$authcode
	$upload	
);

=begin
@photo = (
	"/tmp/pics/beauty25/*.jpg",
	"/tmp/pics/gweny/*.jpg",
	"/tmp/pics/dayle03/*.jpg",
	"/tmp/pics/anne_lyn/*.jpg",
	"/tmp/pics/ayraganda/*.jpg",
	"/tmp/pics/fudgeebar1987/*.jpg",
	"/tmp/pics/ciathevista/*.jpg",
	"/tmp/pics/sweet_sheile/*.jpg",
	"/tmp/pics/alexa4u2009/*.jpg",
	"/tmp/pics/lastlok_jen/*.jpg",
	"/tmp/pics/lovelysam30/*.jpg",
	"/tmp/pics/lyn107/*.jpg",
	"/tmp/pics/lopez25/*.jpg",
	"/tmp/pics/sweetzal/*.jpg",
	"/tmp/pics/carlos_ali/*.jpg",
	"/tmp/pics/fashionsense/*.jpg",
	"/tmp/pics/bahaghari/*.jpg",
	"/tmp/pics/ysawilson/*.jpg",
	"/tmp/pics/kim4u69/*.jpg",
	"/tmp/pics/smarudes/*.jpg",
	"/tmp/pics/twitasia/*.jpg",
	"/tmp/pics/mkris08/*.jpg",
	"/tmp/pics/wckdchq/*.jpg",
	"/tmp/pics/tanyagarcia14/*.jpg",
	"/tmp/pics/laurmae22/*.jpg",
);
=cut

find sub{push @photo, "$File::Find::name/*.jpg" if (-d $File::Find::name);},"/tmp/ustream"; shift(@photo);

@hobby = (
"collecting", "games", "outdoor recreation", "performing arts", "creative hobbies", "scale modeling", "dioramas", "cooking", "gardening", "reading",
"Reef aquarium","Protein skimmer","Reef safe","Marine aquarium","Live rock","Painted fish","Airstone","Tropical fish","Hardy fish","Berlin Method","Takashi Amano","Flowerhorn cichlid","Community aquarium","Coldwater fish","Fishkeeping","Fish food","Spawning triggers","Deep sand bed","Feeder fish","Substrate (aquarium)","Julian Sprung","Dither fish","Disease in ornamental fish","Fish dropsy","Calcium reactor","List of freshwater aquarium amphibian species","Algae eater","Aquarium fish clubs","Herbert R. Axelrod","List of brackish aquarium fish species","Filter (aquarium)","Heater (aquarium)","Aquarium fish feeder","Bath treatment (fishkeeping)","Freshwater aquarium","Aquarium Fish International","Aquarium lighting","Amateur astronomy","Amateur telescope making","Aquarium","Aquascaping","Audiophile","Avocation","Backyard railroad","Beekeeping","Blackhawk Films","Brickfilm","Capping (Mystery Science Theater 3000)","Chambers stove","Change ringing software","Coin magic","Currency bill tracking","Dumpster diving","East Yorkshire Family History Society","Electric football","Electronic kit","Facet","Faceting machine","Field recording","Figure painting (hobby)","Fingerboard (skateboard)","Geocaching","Hobby store","Home movies","Homebuilt","Knitting clubs","LENCO Turntables","Lapidary","Lapidary clubs","Letterboxing","Live steam","Lock picking","Locksport","Magic Youth International","Method ringing","Mine exploration","Model building","Oenophilia","The Outdoor Book for Adventurous Boys","Overclocking","Plamo","Practical joke","Railfan","Ral Partha Enterprises, Inc.","Roadgeek","Rock balancing","Rock polishing","Rubber band ball","Scoubidou","Skoolies","Snow fort","Snowball","Soaper","Society of Cambridge Youths","Society of Young Magicians","Taphophilia","The Open Organization Of Lockpickers","University of London Society of Change Ringers","Urban exploration","Urban lumberjacking","Velology","Videophile","Vivarium","Waymarking","World Wide Knit in Public Day",
);
@book = ("Ali Baba and the Forty Thieves","Allerleirauh","Almondseed and Almondella","Alphege, or the Green Monkey","Ancilotto, King of Provino","Andras Baive","The Angel","Anthousa, Xanthousa, Chrisomalousa","Asmund and Signy","Aurore and Aimée","Babiole","Bash Chelik","The Battle of the Birds","Bawang Putih Bawang Merah","The Bay-Tree Maiden","The Bear","Bearskin","Bearskin","Beauty and Pock Face","Beauty and the Beast","The Bee and the Orange Tree","Bella Venezia","Belle-Belle ou Le Chevalier Fortuné","The Story of Bensurdatu","Biancabella and the Snake","Big Claus and Little Claus","The Bird 'Grip'","The Bird of Truth","Black Bull of Norroway","The Black Thief and Knight of the Glen","Blockhead Hans","Bluebeard","The Blue Belt","The Blue Bird","The Blue Light","The Blue Mountains","The Bold Knight, the Apples of Youth, and the Water of Life","Boots and His Brothers","Boots and the Troll","Boots Who Ate a Match With the Troll","The Boy and the Wolves","The Boy who could keep a Secret","The Boy Who Cried Wolf","The Boy Who Drew Cats","The Boy Who Found Fear At Last","The Boys with the Golden Stars","The Bronze Ring","Brother and Sister","Brother and Sister","The Brown Bear of Norway","The Brown Bear of the Green Glen","Brewery of Eggshells","Bunbuku Chagama","The Buried Moon","Bushy Bride","Buttercup","The Canary Prince","Cannetella","Cap O' Rushes","The Cat on the Dovrefell","The Cat's Elopement","Catherine and her Destiny","Catskin","The Child who came from an Egg","Childe Rowland","A Christmas Carol","Cinderella","The City of Brass","The Clever Little Tailor","Clever Maria","Conall Cra Bhuidhe","Corvetto","Costanza / Costanzo","The Cottager and his Cat","The Crystal Ball","The Cunning Shoemaker","Cupid and Psyche","The Dancing Water, the Singing Apple, and the Speaking Bird","Dapplegrim","The Daughter of Buk Ettemsuch","The Daughter Of King Under-Waves","The Daughter of the Skies","The Death of Abu Nowas and of his Wife","The Death of Koschei the Deathless","Der Mond","The Devil With the Three Golden Hairs","Diamonds and Toads","Diamond Cut Diamond","Dick Whittington","The Dirty Shepherdess","Doctor Know-all","Doll i' the Grass","The Dolphin","Don Giovanni de la Fortuna","Don Joseph Pear","The Donkey","Donkey Cabbages","Donkeyskin","The Dove","Drakestail","The Dragon and his Grandmother","The Dragon and the Prince","The Dragon of the North","East of the Sun and West of the Moon","Eglė the Queen of Serpents","The Elf Maiden","The Elves and the Shoemaker","The Emperor's New Clothes","The Enchanted Canary","The Enchanted Maiden","The Enchanted Pig","The Enchanted Snake","The Enchanted Watch","The Envious Neighbour","Esben and the Witch","Fair Brow","Fair, Brown and Trembling","The Fair Fiorita","Fairer-than-a-Fairy","Fairy Gifts","Fairy Ointment","The False Prince and the True","Farmer Weathersky","Făt-Frumos with the Golden Hair","Father Frost","Father Roquelaure","The Feather of Finist the Falcon","Ferdinand the Faithful and Ferdinand the Unfaithful","Finette Cendron","The Fir-Tree","The Firebird and Princess Vasilisa","The Fish and the Ring","The Fisherman and His Wife","The Fisherman and the Jinni","Fitcher's Bird","The Flea","The Fisher-Girl and the Crab","Five Peas from a Pod","The Flower Queen's Daughter","The Flying Trunk","The Fool of the World and the Flying Ship","Fortune and the Wood-Cutter","Fortunée","Foundling-Bird","The Fountain of Youth","The Four Skillful Brothers","The Fox Sister","Frau Trude","The Frog and the Lion Fairy","The Frog Prince","The Frog Princess","Geirlug The King's Daughter","Garbancito","Georgic and Merlin","Gertrude's Bird","The Giant Who Had No Heart in His Body","The Giants and the Herd-boy","The Gifts of the Magician","The Gingerbread Man","The Girl and the Dead Man","The Girl Without Hands","The Glass Coffin","The Glass Mountain","Go I Know Not Whither and Fetch I Know Not What","The Goat Girl","The Goat's Ears of the Emperor Trojan","The Goat-faced Girl","The Goblin and the Grocer","The Gold-Children","The Gold-bearded Man","The Golden Ball","The Golden Bird","The Golden Blackbird","The Golden Bracelet","The Golden Branch","The Golden Crab","Golden Goose","The Golden-Headed Fish","The Golden Key","The Golden Lion","Goldilocks and the Three Bears","The Golden Slipper","The Gold-spinners","Gold-Tree and Silver-Tree","The Goose Girl","The Goose-Girl at the Well","The Goose That Laid the Golden Eggs","Graciosa and Percinet","The Grateful Beasts","The Grateful Prince","The Greek Princess and the Young Gardener","The Green Knight","The Green Serpent","The Griffin","The Groac'h of the Isle of Lok","Guerrino and the Savage Man","Habogi","The Hairy Man","Half-Man","Hans My Hedgehog","Hansel and Gretel","The Hazel-nut Child","The Heart of a Monkey","The Hedley Kow","Hermod and Hadvor","The Tale of the Hoodie","Hop o' My Thumb","The Horse Gullfaxi and the Sword Gunnfoder","How Geirald the Coward was Punished","How Ian Direach got the Blue Falcon","How the Beggar Boy turned into Count Piro","How the Devil Married Three Sisters","How the Dragon was Tricked","How the Hermit helped to win the King's Daughter","How the Stalos were Tricked","How to find out a True Friend","The Hurds","The Husband of the Rat's Daughter","The Hut in the Forest","The Ill-Fated Princess","I know what I have learned","The Imp Prince","In Love with a Statue","Iron John","The Iron Stove","Issun-bōshi","Jack and his Comrades","Jack and His Golden Snuff-Box","Jack and the Beanstalk","Jack the Giant Killer","The Jackal and the Spring","Jackal or Tiger?","Jesper Who Herded the Hares","Jean, the Soldier, and Eulalie, the Devil's Daughter","The Jezinkas","The Jogi's Punishment","John, the soldier","Jorinde and Joringel","Jullanar of the Sea","The Juniper Tree","Kachi-kachi Yama","Kallo and the Goblins","Kate Crackernuts","Katie Woodencloak","King Fortunatus's Golden Wig","King Kojata","The King of England and his Three Sons","The King of Erin and the Queen of the Lonesome Island","The King Of Lochlin's Three Daughters","The King of Love","The King o' the Cats","The King of the Gold Mountain","The King of the Golden River","King Thrushbeard","The King who Wished to Marry His Daughter","The King Who Would Be Stronger Than Fate","The King who would have a Beautiful Wife","Kisa the Cat","The Knights of the Fish","La Ramée and the Phantom","The Lambkin and the Little Fish","The Language of the Birds","The Lassie and Her Godmother","Laughing Eye and Weeping Eye","The Lazy Spinner","The Light Princess","Little Annie the Goose-Girl","The Little Bull-Calf","Little Cat Skin","Little Daylight","The Little Girl Sold with the Pears","The Little Good Mouse","The Little Green Frog","Little Johnny Sheep-Dung","The Little Match Girl","The Little Mermaid","Little Red Riding Hood","Little Wildrose","Long, Broad and Sharpsight","Lord Peter","The Lost Children","The Love for Three Oranges","Lovely Ilonka","The Lute Player","Madschun","Maestro Lattantio and His Apprentice Dionigi","The Magic Book","The Magic Swan Geese","The Magic Swan","The Magician's Horse","The Magpie's Nest","Maid Maleen","Maiden Bright-eye","The Maiden with the Rose on her Forehead","The Man of Stone","Marcelino, bread and wine","Maroula","Mary's Child","The Master and His Pupil","Master and Pupil","The Master Thief","The Master Maid","The Merchant","The Mermaid and the Boy","Misfortune","Molly Whuppie","Momo Taro","The Months","Mogarzea and his Son","Mossycoat","The Most Incredible Thing","Mother Hulda","Mr Miacca","Mr Simigdáli","My Lord Bag of Rice","My Own Self","Myrsina","The Myrtle","Nature's Ways","The Nettle Spinner","Niels and the Giants","The Nightingale","The Nine Peahens and the Golden Apples","Nix Nought Nothing","The Nixie of the Mill-Pond","The Norka","Nourie Hadig","The Nunda, Eater of People","The Nutcracker and the Mouse King","The Old Dame and Her Hen","Old Hildrebrand","The Old Witch","The Old Woman in the Wood","Old Sultan","One-Eye, Two-Eyes, and Three-Eyes","The One-Handed Girl","The Peasant and the Devil","The Peasant's Wise Daughter","Penta of the Chopped-off Hands","Peruonto","Peter and the Wolf","Peter Pan","The Pied Piper of Hamelin","The Pig King","The Pigeon and the Dove","The Pink","The Adventures of Pinocchio","Pintosmalto","Prâslea the Brave and the Golden Apples","The Story of Pretty Goldilocks","The Pretty Little Calf","Prince Lindworm","Prince Marcassin","Prince Ring","The Princess and the Pea","The Prince and the Princess in the Forest","Prince Hat under the Ground","Prince Hyacinth and the Dear Little Princess","Prince Prigio","Princess Belle-Etoile","The Princess in the Chest","The Princess Mayblossom","The Princess on the Glass Hill","Princess Rosette","The Princess That Wore A Rabbit-Skin Dress","The Princess Who Never Smiled","The Prince Who Wanted to See the World","The Princess Who Was Hidden Underground","Prunella","Puddocky","Puss in Boots","The Queen Bee","The Story of the Queen of the Flowery Isles","The Tale of the Queen Who Sought a Drink From a Certain Well","The Ram","Rapunzel","The Raven","The Raven","The Red Ettin","The Red Shoes","The Rich Brother and the Poor Brother","Ricky with the Tuft","The Riddle","A Riddling Tale","The Rider Of Grianaig, And Iain The Soldier's Son","The Ridere of Riddles","The Ridiculous Wishes","The Robber Bridegroom","Rosanella","The Rose-Tree","Rumpelstiltskin","Rushen Coatie","Sadko","Sapia Liccarda","Schippeitaro","The Sea-Maiden","The Seven Foals","The Seven Ravens","The Shadow","The Sharp Grey Sheep","The She-Bear","The Tale of the Shifty Lad, the Widow's Son","Shita-kiri Suzume","Seven Voyages of Sindbad the Sailor","Shortshanks","The Silent Princess","The Singing Bone","The Singing, Springing Lark","The Sister of the Sun","The Six Swans","The Slave Mother","Sleeping Beauty","The Sleeping Knight","The Sleeping Prince","The Small-tooth Dog","The Snake Prince","The Snow Maiden","Snegurochka","The Snow Queen","Snow White","Snow-White and Rose-Red","Snow-White-Fire-Red","The Soldier and Death","The Sorcerer's Apprentice","Soria Moria Castle","Spindle, Shuttle, and Needle","The Spirit in the Bottle","The Sprig of Rosemary","Stan Bolovan","The Star Money","Starlight (fairy tale)","The Steadfast Tin Soldier","The Stonecutter","Stone soup","Strega Nona","A String of Pearls Twined with Golden Flowers","Sweet porridge","Sweetheart Roland","The Swineherd","The Tailor in Heaven","The Story of Tam and Cam","Tattercoats","Tatterhood","The Tale of the Bamboo Cutter","The Tale of Tsar Saltan","The Thief and His Master","Thirteenth","The Thirteenth Son of the King of Erin","The Three Apprentices","The Three Aunts","Three Billy Goats Gruff","The Three Crowns","The Three Daughters of King O'Hara","The Three Dogs","The Three Enchanted Princes","The Three Fairies","The Three Heads in the Well","The Three Languages","The Three Little Birds","The Three Little Men in the Wood","Three Little Pigs","The Three May Peaches","The Three Princes and their Beasts","The Three Princesses of Whiteland","The Three Sisters","The Three Spinners","The Three Treasures of the Giants","The Story of Three Wonderful Beggars","Thumbelina","The Tinder Box","Tom Thumb","Tom Tom and his Apple Machine","A Tale Of the Tontlawald","To Your Good Health!","Town Musicians of Bremen","Tritill, Litill, and the Birds","The Troll's Daughter","True and Untrue","The True Bride","Trusty John","Tsarevitch Ivan, the Fire Bird and the Gray Wolf","The Turnip","The Twelve Brothers","Twelve Dancing Princesses","The Twelve Huntsmen","The Twelve Months","The Twelve Wild Ducks","The Two Brothers","The Two Caskets","The Two Kings' Children","Udea and her Seven Brothers","The Ugly Duckling","The Unlooked for Prince","Urashima Tarō","The Valiant Little Tailor","Vasilii the Unlucky","Vasilisa The Priest’s Daughter","Vasilissa the Beautiful","Virgilius the Sorcerer","Water and Salt","The Water Nixie","The Water of Life","The Water of Life","The Water Mother","The Well of the World's End","What came of picking Flowers","What Is the Fastest Thing in the World?","What the Rose did to the Cypress","The White and the Black Bride","White-Bear-King-Valemon","The White Cat","The White Doe","The White Dove","The White Dove","The White Duck","The White Snake","Why the Sea Is Salt","Whuppity Stoorie","The Wicked Sisters","The Willful Child","The Wise Little Girl","The Wise Woman, or The Obstinate Princess: A Double Story","The Witch","The Witch in the Stone Boat","The Wizard King","The Wolf and the Seven Young Kids","The Wonderful Birch","The Wonderful Musician","The Wonderful Tune","The Wonderful Wizard of Oz","The Wounded Lion","The Yellow Dwarf","The Young King Of Easaidh Ruadh","The Young Slave","The Story of the Youth Who Went Forth to Learn What Fear Was","The Story of Zoulvisia","Kancil Nyolong Timun");
@genre = ("Avant-garde","Experimental music","Minimalist music","Lo-fi","Country","Alternative country","Americana","Country pop","Nashville sound/Countrypolitan","Urban Cowboy","Country rock","Honky tonk","Bakersfield Sound","Progressive country","Neotraditional country","Outlaw country","Rockabilly","Traditional country","Bluegrass","Progressive bluegrass","Traditional bluegrass","Close harmony","String band","Western","Western swing","Jazz","Acid jazz","Asian American jazz","Avant-garde jazz","Bebop","Big band","Crossover jazz","Dixieland","Calypso jazz","Chamber jazz","Cool jazz","Free jazz","Gypsy jazz","Hard bop","Jazz blues","Jazz-funk","Jazz fusion","Jazz rap","Latin jazz","Mainstream jazz","Mini-jazz","Modal jazz","M-Base","Nu jazz","Smooth jazz","Soul jazz","Swing","Trad jazz","West Coast jazz","Blues","Boogie-woogie","Country blues","Delta blues","Electric blues","Jump blues","Easy listening","Background music","Beautiful music","Elevator music","Furniture music","Lounge music","Middle of the road",,"Electronic","Ambient","Dark ambient","Breakbeat","Dance","Big beat","Dubstep","Drum and bass","Darkcore","Electroclash","Eurodance","Gabba","Garage","Goa trance","Psychedelic trance","Happy hardcore","Hardcore techno","Hi-NRG","House","Acid house","Ambient house","Italo house","Kwaito","IDM","Spacesynth","Trance","Acid","Classic","Euro","Hard","Hardstyle","Progressive trance","Tech","Uplifting","Vocal","Electro","Electronica","Folktronica","Rave","Techno","Acid breaks","Trip hop","Downtempo","Glitch","Industrial music","Progressive electronic","Hip hop/Rap music","Australian hip hop","Canadian hip hop","Crunk","Dirty rap/Pornocore","East Coast hip hop","Gangsta rap","G-funk","Grime","Latin rap","Chicano rap","Miami bass","Midwest hip hop","Political hip hop","Southern hip hop","Turntablism","West Coast hip hop","Latin","Bossa Nova","Mambo","Merengue","Música Popular Brasileira","Reggaeton","Salsa","Samba","Tejano","Tropicalismo","Zouk",,"Pop","Adult contemporary music","Adult oriented pop music","Afropop","Arab pop","Austropop","Balkan pop","Baroque pop","Brazilian pop","Bubblegum pop","Chinese pop","Contemporary Christian","Country pop","Dance-pop","Disco","Disco polo","Electropop/Technopop","Eurobeat","Euro disco","Europop","French pop","Greek Laïkó pop","Hong Kong and Cantonese pop","Hong Kong English pop","Indian pop","Indonesian pop","Italo dance","Italo disco","Jangle pop","Japanese pop","Korean pop","Latin pop","Levenslied","Louisiana swamp pop","Mandarin pop","Manufactured pop","Mexican pop","Nederpop","New romantic","Noise pop","Operatic pop","Persian pop","Pop rap","Psychedelic pop","Russian pop","Schlager","Sophisti-pop","Space age pop","Sunshine pop","Surf pop","Synthpop","Taiwanese pop","Teen pop","Thai pop","Traditional pop music","Turkish pop","US pop","Vispop","Wonky Pop","Yugoslav pop","Modern folk","Indie folk","Neofolk","Progressive folk","Reggae","2 tone","Dancehall","Dub","Lovers rock","Ragga","Reggaefusion","Rocksteady","Ska",,"Rhythm and blues","Contemporary R&B","Doo wop","Funk","Deep Funk","Go-go","P-Funk","New jack swing","Soul","Hip hop soul","Northern soul","Neo soul","Urban contemporary","Rock","Alternative rock","Britpop","Dream pop","Emo","Gothic rock","Grunge","Post-grunge","Indie rock","C86","Industrial rock","Indie pop","Madchester","Post-rock","Shoegazing","Blues-rock","C-Rock","Dark cabaret","Desert rock","Folk rock","Garage rock","Glam rock","Hard rock","Heavy metal","Black metal","Christian metal","Death metal","Doom metal","Folk metal","Glam metal","Gothic metal","Grindcore","Groove metal","Industrial metal","Metalcore","Deathcore","Mathcore","Melodic metalcore","Nu metal","Power metal","Progressive metal","Rap metal","Sludge metal","Speed metal","Symphonic metal","Thrash metal","Unblack metal","J-Rock","Math rock","New Wave","Paisley Underground","Pop rock","Power pop","Progressive rock","Psychedelic rock","Acid rock","Punk rock","Anarcho punk","Crust punk","Deathrock","Hardcore punk","Post-hardcore","Pop punk","Post-punk","Psychobilly","Rap rock","Rapcore","Rock and roll","Soft rock","Southern rock","Surf rock","World","Worldbeat","Afrobeat");
@show = (
	"Cebu Report","The Correspondents","Emergency","Imbestigador","I-Witness","Jessica Soho Reports","Kapuso Mo, Jessica Soho","Kaagapay","Mobile Kusina","Pinoy Abroad","Pinoy Meets World","Pipol","Probe","Private I","Reporter's Notebook","SINE TOTOO: The Best of Serbisyong Totoo","S.O.C.O.","Special Assignment","Victim","Victim: Undercover","Wish Ko Lang","XXX",
	"Beat the Clock (1950)","Truth or Consequences (1950)","Susume! Denpa Shōnen (進め!電波少年) (1992) (Japan)","How do you like Wednesday? (水曜どうでしょう) (1996) (Japan)","Expedition Robinson (1997)","Shiawase Kazoku Keikaku (しあわせ家族計画) (1997) (Japan)","Susunu! Denpa Shōnen (進ぬ!電波少年) (1998-2002) (Japan)","Big Brother (1999) (Netherlands)","Who Wants to Be a Millionaire (1999) (US)","The Weakest Link (1999) (US)","Big Brother (UK) (2000 - present)","Survivor (2000)","The Mole (2000)","The Amazing Race (2001)","Boot Camp (2001)","Cannonball Run 2001 (2001)","Fear Factor (2001)","Lost (2001)","Murder in Small Town X (2001)","Pilipinas, Game KNB? (2001) Dubbed as The Best Philippine Gameshow (Philippines)","Beg, Borrow & Deal (2002-2003)","Endurance (2002) (US)","I'm a Celebrity... Get Me Out of Here! (2002- present) (UK)","I'm a Celebrity... US version (US)","Model Flat (Fashion TV, 2002)","Under One Roof (2002)","Dog Eat Dog (2003)","Drop the Celebrity (2003) (UK)","Celebrity Farm (2003)","The Games (2003) (UK)","Paradise Hotel (2003)","Való Világ (2003) (Hungary)","Back To Reality (2004) (UK)","Peking Express (2004) (BEL/NED)","The Benefactor (2004)","The Code Room (2004)","The Farm (2004) (UK)","Forever Eden (2004)","Gana la Verde (2004) (US; Spanish language)","I'm Famous and Frightened! (2004) (UK)","Mad Mad House (2004)","Quest USA, Da Tiao Zhan (2004) (US)","Shattered (2004) (UK)","Actuality TV's Casting Call (2005) (US)","Infinite Challenge (2005~present) (Korea)","Vyvolení (2005) (Czech Repubblik, Slovakia)","Pinoy Big Brother (2005) (Philippines)","Shipwrecked: Battle of the Islands (2006) (UK)","Deal or No Deal (2006) (US)","Solitary (2006) (US)","Treasure Hunters (2006) (US)","Ultimate Challenge (2006) Pakistan first adventure based reality show","Unan1mous (2006) (US)","Pirate Master (2007) (US)","Total Drama Island (2007) (Canada) (Animated Reality Series)","Britain's Got Talent (2008) (UK)","I Love Money (2008)","Wipeout (2008) (US)","I Survived a Japanese Game Show (2008) (US)","13: Fear Is Real (2009) (US)","The Great American Road Trip (2009) (US)",
	"Propose Daisakusen (プロポーズ大作戦) (1973) (Japan)","Punch de Date (パンチDEデート) (1973) (Japan)","Love Attack! (ラブアタック!) (1975) (Japan)","Neruton Benikujiradan (ねるとん紅鯨団) (1987) (Japan)","Ainori (あいのり) (1999) (Japan)","Blind Date (US) (1999)","Who Wants to Marry a Multi-Millionaire? (2000)","The 5th Wheel (2001)","Chains of Love (2001)","12 Corazones (2006)","Dismissed (2001)","Farmer Wants a Wife (2001) (UK)","Five Go Dating (2001) (UK)","Temptation Island (2001)","Who Wants to Be a Princess (2001)","The Bachelor (2002)","Bachelorettes in Alaska (2002)","ElimiDATE (2002)","EX-treme Dating (2002)","Meet My Folks (2002)","Shipmates (2001)","Streetmate (UK)","Would Like To Meet (UK)","Average Joe (2003)","The Bachelorette (2003)","Cupid (2003)","For Love or Money (2003)","Joe Millionaire (2003)","Married by America (2003)","Mr. Personality (2003)","Room Raiders (2003)","Three's a Crowd (game show) (2003) (UK)","My Big Fat Obnoxious Fiancé (2004)","Boy Meets Boy (2004)","The Littlest Groom (2004)","Outback Jack (2004)","The Player (2004)","Playing It Straight (US - 2004, UK - 2005)","Date My Mom (2004)","Who Wants to Marry My Dad? (2004)","The Ultimate Love Test (2004) (US)","Beauty and the Geek (2005)","Celebrity Love Island (2005) (UK)","How to Get Lucky (2005) (UK)","Next (2005)","Shopping for Love (2005) (Australia)","Chantelle's Dream Dates (2006) (UK)","Estoy Por Tí (Spain)","Flavor of Love (2006)","I Love New York (2007)","Parental Control (2006)","Matched in Manhattan (2006)","Age of Love (2007)","Rock of Love with Bret Michaels (2007)","MTV Splitsvilla (2007) (India)","Transamerican Love Story (2008)","When Spicy Meets Sweet (2008)","Real Chance of Love (2008)","Momma's Boys (2008)","For the Love of Ray J (2009)",
);

@movie = (
"2000","The 6th Day ","Battlefield Earth ","The Cell ","Escaflowne ","Frequency ","Godzilla vs. Megaguirus ","Happy Accidents ","Hollow Man ","I.K.U. ","K-PAX ","The Last Man ","Mission to Mars ","Pitch Black ","Possible Worlds ","Red Planet ","Space Cowboys ","Supernova ","Titan A.E. ","What Planet Are You From? ","X-Men ","2001","A.I.: Artificial Intelligence ","Atlantis: The Lost Empire ","Avalon ","The American Astronaut ","Donnie Darko ","Electric Dragon 80.000 V ","Evolution ","Final ","Final Fantasy: The Spirits Within ","Ghosts of Mars ","Godzilla, Mothra and King Ghidorah: Giant Monsters All-Out Attack ","Hey, Happy! ","Jurassic Park III ","The Lost Skeleton of Cadavra ","Metropolis ","Mind Storm ","Nabi ","The One ","Planet of the Apes ","The Princess Blade ","Replicant ","The Strange Case of Señor Computer ","Vanilla Sky ","2002","28 Days Later ","The Adventures of Pluto Nash ","Clockstoppers ","Cowboy Bebop: The Movie ","Cube 2: Hypercube ","Cypher ","Dead or Alive:Final ","Eight Legged Freaks ","Equilibrium ","Godzilla Against Mechagodzilla ","Happy Here and Now ","Impostor ","Jason X ","Men in Black II ","Minority Report ","Project Viper ","Reign of Fire ","Resident Evil ","Returner ","Rollerball ","S1m0ne ","Signs ","So Close ","Solaris ","Spider-Man ","Star Trek Nemesis ","Star Wars Episode II: Attack of the Clones ","Tamala 2010: A Punk Cat In Space ","Teknolust ","Treasure Planet ","The Time Machine ","Timequest ","2003","2009: Lost Memories ","Code 46 ","The Core ","Dreamcatcher ","Godzilla: Tokyo SOS ","Good Boy! ","Hulk ","Interstella 5555: The 5tory of the 5ecret 5tar 5ystem ","It's All About Love ","Koi Mil Gaya ","The Matrix Reloaded ","The Matrix Revolutions ","Natural City ","Paycheck ","Robot Stories ","Terminator 3: Rise of the Machines ","Timeline ","Undead ","Wonderful Days ","WXIII: Patlabor the Movie 3 ","X2 ","2004","2046","After the Apocalypse ","Alien vs. Predator ","Appleseed ","The Butterfly Effect ","Casshern ","The Chronicles of Riddick ","The Day After Tomorrow ","Decoys ","Eternal Sunshine of the Spotless Mind ","FAQ: Frequently Asked Questions ","The Final Cut ","Godzilla: Final Wars ","I, Robot ","Immortel (ad vitam) ","Innocence: Ghost in the Shell ","Night Watch ","Primer ","Resident Evil: Apocalypse ","Sky Captain and the World of Tomorrow ","Spider-Man 2 ","The Stepford Wives ","Thunderbirds ","2005","A Sound of Thunder ","Æon Flux ","Alien Abduction ","The Cave ","Doom ","Fantastic Four ","Final Fantasy VII Advent Children ","The Girl From Monday ","H.G. Wells' The War of the Worlds ","The Hitchhiker's Guide to the Galaxy ","The Island ","Man with the Screaming Brain ","Meatball Machine ","Planetfall ","Puzzlehead ","Robots ","Serenity ","Slipstream ","Star Wars Episode III: Revenge of the Sith ","Steamboy ","War of the Worlds ","The Wild Blue Yonder ","Zathura: A Space Adventure ","2006","A Scanner Darkly ","Aachi & Ssipak ","Altered ","Aziris Nuna ","Children of Men ","Day Watch ","Déjà Vu ","Displaced ","The Fountain ","Gamera the Brave ","The Host ","Idiocracy ","Krrish ","Lifted ","Paprika ","Renaissance ","Southland Tales ","Slither ","Superman Returns ","Ultraviolet ","Unidentified ","V for Vendetta ","X-Men: The Last Stand ","Zerophilia ","2007","Aliens vs. Predator: Requiem ","Appleseed Ex Machina ","28 Weeks Later ","Chrysalis ","Eden Log ","Fantastic Four: Rise of the Silver Surfer ","Flatland The Film ","I Am Legend ","Illegal Aliens ","The Invasion ","Next ","Meet the Robinsons ","Paragraf 78, Punkt 1 ","Resident Evil: Extinction ","Spider-Man 3 ","Sunshine ","Timecrimes ","Transformers ","The Man from Earth ","Trust. Welfare ","Underdog ","Vexille ","2008","Alien Raiders ","Babylon A.D. ","CJ7 ","Cloverfield ","Dante 01 ","The Day the Earth Stood Still ","The Day the Earth Stopped ","Death Race ","Doomsday ","Far Cry ","Franklyn ","The Happening ","The Inhabited Island ","The Incredible Hulk ","Iron Man ","Jumper ","Love Story 2050 ","Meet Dave ","The Mutant Chronicles ","Outlander ","PROXIMA ","Sleep Dealer ","Star Wars: The Clone Wars ","Tokyo Gore Police ","WALL-E ","The X-Files: I Want to Believe ","2009","2012","9","Alien Trespass ","Astroboy ","Battle for Terra ","The Box ","District 9 ","Gamer ","Knowing ","Land of the Lost ","Monsters vs. Aliens ","Moon ","Pandorum ","Planet 51 ","Push ","Race to Witch Mountain ","The Road ","Star Trek ","Stingray Sam ","Surrogates ","Terminator Salvation ","The Time Traveler's Wife ","Transformers: Revenge of the Fallen ","Watchmen ",
);

@firstname = ("Angel","Nicole","Angelica","Angela","Jasmine","Mary Joy","Kimberly","Mariel","Mary Grace","Princess");
@secondname = (
"Sophia","Emily","Chloe","Tiffany","Angela","Ashley","Rachel","Isabella","Fiona","Jessica","Sarah",
);
@middlename = ("Santos","Reyes","Cruz","Bautista","Ocampo","García","Mendoza","Tomás","Andrada","Castillo","Flores","Villanueva","Ramos","Castro","Rivera","Aquino","Navarro","Salazar","Mercado","Concepción","Santiago","Lopez","de la Cruz","de la Reyes","del Rosario","de los Santos","de Guzmán","de Castro","de la Vega","de la Rosa","de Asis","de Rosales","González","López","Hernández","Pérez","Fernández","Ramírez","Dominguez","Enriquez","Álvarez","Sánchez");
@lastname = (
"Santos","Reyes","Cruz","Bautista","Ocampo","García","Mendoza","Tomás","Andrada","Castillo","Flores","Villanueva","Ramos","Castro","Rivera","Aquino","Navarro","Salazar","Mercado","Concepción","Santiago","Lopez","de la Cruz","de la Reyes","del Rosario","de los Santos","de Guzmán","de Castro","de la Vega","de la Rosa","de Asis","de Rosales","González","López","Hernández","Pérez","Fernández","Ramírez","Dominguez","Enriquez","Álvarez","Sánchez",
"Silva","Santos","Oliveira","Souza","Pereira","Costa","Carvalho","Cavalcanti","Gonçalves","Almeida","Ferreira","Ribeiro","Rodrigues","Gomes","Lima","Martins","Rocha","Alves","Araújo","Pinto","Barbosa","Castro","Fernandes","Melo","Marchi","Azevedo","Barros","Cardoso","Correia","Cunha","Dias",
);

my @aboutx = (
"hi... im single available and im looking for a futire husband
in this site and im willing to relocate to other country if given a chance,,,i
like listening to music and go to beaches for relaxation,, i love playing
volleyball,,and reading love and romances stories,,,i love to watch movies
especially love stories,, i love to cook.. i am a family centered and god
fearing person, family oriented,,,im adventurous i love to travel new places and
discover new sites...i also love fishing,i love to see waterfalls,green
leaves,mountains,rivers and i love mother nature...and most i love to watch the
sunset,.......!!",
"sweet and loving...looking for someone whom i could share with my love... i
live with family with much hardship we are all fifteen excluding my parents. my
father only works and some of my brother also got their own family and kids, i
got two sisters who got babies at their very young age and the father went away
from their responsibility. after me, i still have younger sisters and brothers.i
still even have a four-month old sister...with the situation i have around, it
makes me felt and teach myself to be better...and wanna succeed in life. i want
to be better and will keep myself away from the things that would maybe doomed
me same as what with my sisters have. i wanna go back to school and develop
myself more...",
"im simple,,i have cute dimples,,sweet,,honest,,and specially im not cheating
girl.. ",
"i'm a down toh earth & a hapee go lucky gurl whom they often describe me as
sweet,lovable caring person.. i am good in understanding the feelings of people
as long as i can relate and as long as am in the moodâ€¦. i'm someone you can
trust..i envy people who can't fit w/out trying to..love chillin with funny
people and those with some sense of humor ..i love those people who makes me
laugh all day , those who won't make me frown even for a day..im a one woman
man.,im not aftering for material things..well, am leaving as simple
and happy.. if ur interested mail me ,.",
"im still studying im taking up
business administration. and also i have sense of humor, down to earth, aside
from that i love also dancing, playing instrument, and have fearing in god,
and have a good heart..",
"i am not a perfect human but i am trying my best to be a good person.. i am
honest and loyal to my friends,i am sincere in finding my everlasting and last
love in my life...i am funny person but when it serious i am serious also...i
like going beach and reading some books.. like fary tales and etc.i like to be
an independent person and stand to my own feet...i am down to earth person
which is people like me...i have old fashion values and warm caring heart,
sweet candid loving and open minded person..easy to going and creative person
with a sense of humor.happy girl'' with and much more of that when you get to
know me... remember people fall in love not knowing why? or how, its's
special that dosent requier much answers, just love no matter how STUPID you
become ;-0 ",
"im a woman with a full of life, sweet, romantic and honest .and a good companion
in life too,im hoping that this site is finally find my man in life. that can
establish happy family, im looking for a serious relationship .and a good guy to
be a life time partner,i m a good cook loving and caring woman. please if you
want to know more about me, just send me a message.",
"i'm a very simple young lady who wants to meet different types of people in this
world.i'm a very flexible person, i'm understanding and sincere. i'm very loyal
to my friends and loved ones. i cannot afford to betray someone. some might
think that revenge seems to be the right thing to do to a person who had hurt
you, but for me it's not like that.. i live with a principle and have a stand in
my life. when i trust, i trust and its up to the person to keep or break that
trust i have for him/her. i am very friendly, in fact i have a lot of
friends...friends that truly love and value me. i love sports too. during my
high school and college years i've been into different types of sports. i get
too addicted to them that i can't seem to live without them. i play
soccer-baseball, tennis and many other sports. let's just say i'm kinda sporty
though. i love sports and love to read books as well.:)",
"im a single lady from philippines.. im a high school graduate. i grew up in
county side specifically in my grand father and mother's farm. im an aspiring
model and singer as well but not now as my fulltime career but i also love
having family so soon or to be in school. i love to find a wonderful prince
charming in life hopefully godfearing and supportive to any career i want to
have..",
"i am sweet,caring,most specially a loving person..i have beautiful long hair.",
"i am a very simple person. ilove to meet other people.i am a half fil half
austrian with a bit of chines.im easy to be with. i also give my best in a
relation and also what my partner wants.",
"well im just a very simple girl..contempted of what i hve now...love to sing and
dance...outing with my friends,,traveling other cities hre in negros and watch
thier festivals... i love watching movies...specially romance movie..i like
sunbating on the beach..playing volleyball...im a sportminded.. JUST TALK TO ME
AND YOU WILL KNOW MORE ABOUT ME...SEE YOU'''",
"i am just a ghurl.. _a lovable,caring,sweet,so fimine and kind... haay i cant
tnik of anymore... just be with meh and you will knw the real
meh!! _'thankx...",
"simple beauty,sweet lady,and i am a true real blooded filipina woman,have a
faith in god,and funny girl,and loving",
"i live alone here and iam
far to my family and iam working student here...i been cheated before afilipino
man...so why iam here bcos i want a seriuos relationship so iam seriuos woman
iam anice woman honest faithful respectful carring loving and one man woman..iam
responsible..so iam seriuos to find my man..so pleased be seriuos an pleased be
honest...bcos i hate lier and playboy....so iam not here for plyagames...iam
here for seriuos relationship...",
"i ahve shoty hair , and fair complexio, im about 5,5 slim and sexy, im easy
going faithful honest and attractive",
"white, cute, nice girl and honest and i am also frindly....... im a single
lady........... . .......................",
"loves to laugh,loves to smile,hates to cry but cries a lot,loves to swim,
but hates the sun, loves to cook,loves to eat..eat eat eat!i love food!! loves
ice cream and chocolates loves pastas,loves strawberries,apple and water melon,
loves to sing & dance, love reading books.lol :) a full-time killer and a
part-time easy kill.. you'll dig it if you're a jimmy eat world fan sweetie. ;)
i'm a very emotional person with a broad range of emotions from the highest
highs to the lowest lows. i feel emotional situations very strongly. i'll flash
to the very peaks of elation, sweeping everything before me. then, for some
reason unknown to myself, i will burn out emotionally. these mood swings can be
very disturbing to me. sometimes, i feel that i can no longer produce anything.
but, after given some time alone to \"recharge my emotional batteries\", i will
spring back into action. i react impulsively, without much thought before hand.
i may plan everything in detail before i even begin, then do it completely
different when the time comes to carry it through. i can also be defiant. i
sometimes have the attitude that if someone doesn't like it the way i'm doing
it, then we can just \"go to hell!\" this trait may reveal itself in a rebellious
nature that is always ready to resist forces which i think are infringing upon
my freedom of action. i have a very creative mind. i like expressing how i
feel, what i am doing, and what i plan to do. i am a people person. i have a
healthy imagination, and i display a fair amount of trust. i let new people
into my circle of friends. i use my imagination to understand new ideas,
things, and people. and lastly, i desire being told that i am loved, every day.
=)",
"askin' bowt dis ghurl? i think one word that would best describe gotta be \"god
fearing!\" yupiez! corny& mushy it may seem but tru! m a genuine person to! i
love eatin!duno y sme pipz olwez mke sme crazy gossip btw meh but hu cares! m
juz being mah self! well, all i can say is that m tru and because of it i rock!
and mah words \" i dnt wana b compared to anyone coz im different and unique\"
s-ophisticated t-rue/trust worthy e-legant p-ositive
thinker h-umble a-dmirable n-ice i-ntelligent e-verythin' rolled into one!
hehehehe:)",
"sweet,loving and caring. . .stick to one..simple and understanding. . .",
"am simple and nice person...hmmm...just see me in personal guys..hhhehehehehehhe",
"..i take life with a grain of salt, a wedge of lime and a shot of tequila..",
"nice, sweet, fun loving, outgoing, easy to be with loves adventure",
);

my @meetx = (
"nice, understanding, sensual, supportive, open-minded, fun loving",
"someone who sems to be interesting..",
"am just looking for friends now and see where it lead to you have to start out
as friend first to get a good relationship with that person in order to know
them better...",
"i like meeting person who can understand me!!! i am the kind of person shy at
first!!! i am the kind of person who loves music!!!",
"a nice man..he love's me for what i am....hehehehe be nice to me and love me
forever...thats all...:)",
"\"Love is patient, love is kind. It does not envy, it does not boast, it is not
proud. It is not rude, it is not self-seeking, it is not easily angered, it
keeps no record of wrongs. Love does not delight in evil but rejoices with the
truth. It always protects, always trusts, always hopes, always
preserves.\" these speaks all of what i want to meet and be with forever.",
"im looking for good man to love me all the time to caring me like a baby....and
honest to me....",
"a guy who will accept me for what i am...a guy who will love me for the rest of
his life...hve god fearing... he must love me for what i look like ...he must
liike my friends and my parents too,,my brother..WHERE ARE YOU NOW? IM LOOKING
FOR YOU''':)",
"anyone whos willing to meet me in person.a person that is sweet.and can bring me
to travel.also i want a person whoi can handle my moods.because in return,ill
give him what he wants",
"soul searching me....!!! hi guys, how are you??? im looking for a
serious,sencere,loving, and understanding future husband in this site...do you
have what it takes??? are you here?? where are you now??? im waiting for
you..just message me..thank you and goodluck!!!!",
"if you have read my description about me, and understood it. thank you so much
for still reading until here. the reason why i am here is to find someone whom
will be loving me and helping me to better person. i wanna go back to school. i
am not saying the story about my family...because i want you to support all of
us. when you like me, please accept and understand that i will be asking my
special someone to let me back to school. i just finished my sixth grade by a
help of my friend but she cannot support me all the way and been on this age and
still haven't step to high school. i wanna help myself and hope to someone who
will accept and would love me with his whole heart will also help me to be
better. i hope you understand. please don't message me when you just after
for my beauty and body. be after my heart and soul.",
"kind person heart... specially not cheating.. have moral values....",
"a man who is bounded with humanity and streghten with dignity... i want a
serious long term relationship... a man who will love me for who i am.
caring, understanding..someone who is kind at heart.. faith ful and trust
worty.. any one who is honest and will respect me with my culture... someone
who would trust and no doubts with me..in here i dont expect that all man is
good.. you could only found out if that certain person is good or bad if you
got a long conversation to each other.. i i dont want people who are
so addicted to sex who is usually in every website i hate guys who played
games with.. im looking in a real relationship'' a seruios a marrage'' but i am
not saying that all guys are bad' i just encounterd but but hopefully i found
mine and to be haapy with him'' but i can say most.. ",
"i am looking for a man who is willing to accept me as me..who's gonna take good
care of me and who would play around with my emotions..",
"whatim looking for is a healthy guy with prowess to build a good family or being
very flexible and supportive to me and in return give him warm and support
too.age does not matter if what god wants thy will be done . but i must say
that compatibility is a must.",
);

$email = shift(@ARGV);
$password = shift(@ARGV);
$dir = shift(@ARGV) || rand();
$upload = shift(@ARGV);  

$crawler = FriendsterMobileProfileBrowser->new(
	email => $email,
	password => $password,
	dir => "$email/" . $dir,
);


@hobby = &randarray(@hobby);
@book = &randarray(@book);
@genre = &randarray(@genre);
@show = &randarray(@show);

@about = &randarray(@about);
@meet = &randarray(@meet);

@movie = &randarray(@movie);

@firstname = &randarray(@firstname);
@secondname = &randarray(@secondname);
@middlename = &randarray(@middlename);
@lastname = &randarray(@lastname);

@photo = &randarray(reverse(@photo));

$hobby = join(',',splice(@hobby, 1, 20));
$book = join(',',splice(@book, 1, 20));
$genre = join(',',splice(@genre, 1, 20));
$show = join(',',splice(@show, 1, 20));

$movie = join(',',splice(@movie, 1, 20));

$about = join(',',splice(@about, 1, 1));
$meet = join(',',splice(@meet, 1, 1));

$firstname = join(',',splice(@firstname, 1, 1));
$secondname = join(',',splice(@secondname, 1, 1));
$middlename = join(',',splice(@middlename, 1, 1));
$lastname = join(',',splice(@lastname, 1, 1));

$firstname = "$firstname $secondname";

$photo = join(',',splice(@photo, 1, 1));

$about =~ s/\"/\\\"/g;
$meet =~ s/\"/\\\"/g;

use constant URL_EDIT_PROFILE => 'http://www.friendster.com/editprofile.php';
use constant FILE_EDIT_PROFILE => 'file_edit_profile.htm';
use constant REGEX_INPUT_AUTHCODE => '<input type\=\"hidden\" name\=\"authcode\" value\=\"(.+?)\">';

use constant PROGRAM_SKIN_EDITOR => 'perl friendster-mobile-skin-edit.pl';
use constant PROGRAM_PHOTO_UPLOADER => 'perl friendster-mobile-photo-upload.pl';
use constant PROGRAM_ACCOUNT_EDITOR => 'perl friendster-mobile-editaccount.pl';

#editprofile.php?authcode=8d1d6fff7ab5be400328660137daba&form_id=prof_aboutme&interests=&favoritebooks=&favoritemovies=&favoritemusic=&favoritetv=&aboutme=&inputcount_about_me=5000&wanttomeet=+&inputcount_meet=4999&Submit=Save

$crawler->browse(URL_EDIT_PROFILE, FILE_EDIT_PROFILE);
$authcode = $crawler->{crawler}->find(FILE_EDIT_PROFILE, REGEX_INPUT_AUTHCODE, 1);

$wget_edit_profile = "--post-data \"authcode=$authcode&form_id=prof_aboutme&interests=$hobby&favoritebooks=$book&favoritemovies=$movie&favoritemusic=$genre&favoritetv=$show&aboutme=$about&inputcount_about_me=5000&wanttomeet=$meet&inputcount_meet=5000&Submit=Save\"";

$crawler->browse(URL_EDIT_PROFILE, FILE_EDIT_PROFILE, $wget_edit_profile);

#authcode=8d1d6fff7ab5be400328660137daba&form_id=prof_basic&firstname=first+name&lastname=last+name&maidenname=maiden+name&birthmonth=04&birthday=10&birthyear=1990&gender=f&heretohelp=y&status=2&Submit=Save

$wget_edit_profile = "--post-data \"authcode=$authcode&form_id=prof_basic&firstname=$firstname&lastname=$lastname&maidenname=$middlename&birthmonth=04&birthday=10&birthyear=1990&gender=f&heretohelp=y&status=2&Submit=Save\"";

$crawler->browse(URL_EDIT_PROFILE, FILE_EDIT_PROFILE, $wget_edit_profile);

system(PROGRAM_SKIN_EDITOR . " $email $password $dir");
system(PROGRAM_ACCOUNT_EDITOR . " $email $password $dir");

if($upload)
{
	system(PROGRAM_PHOTO_UPLOADER . " $email $password $dir $photo");
}

sub randarray {
        my @array = @_;
        my @rand = undef;
        my $seed = $#array + 1;
        my $randnum = int(rand($seed));
        $rand[$randnum] = shift(@array);
        while (1) {
                my $randnum = int(rand($seed));
                if ($rand[$randnum] eq undef) {
                        $rand[$randnum] = shift(@array);
                }
                last if ($#array == -1);
        }
        return @rand;
}

