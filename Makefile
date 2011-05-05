CC			:= coffee
JSDIR		:= js
FLAGS		:= -o $(JSDIR) -c
JAVASCRIPTS	:= js/item.js js/main.js js/storage.js
PWDNAME		:= $(shell basename `pwd`)

all: $(JAVASCRIPTS)

extension: $(JAVASCRIPTS)
	@$(CHROMEBROWSER) --pack-extension=`pwd`
	@mkdir -p bin
	@mv ../$(PWDNAME).crx ../$(PWDNAME).pem `pwd`/bin
	
	
	

js/item.js: src/item.coffee
	@mkdir -p js
	@$(CC) $(FLAGS) $<
	
js/main.js: src/main.coffee
	@mkdir -p js
	@$(CC) $(FLAGS) $<

js/storage.js: src/storage.js
	@mkdir -p js
	@cp $< $(JSDIR) 

.PHONY : clean
clean:
	@rm -fR js
	@rm -fR bin

	

	
