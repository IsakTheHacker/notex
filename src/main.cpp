#include <SFML/Graphics.hpp>
#include "editorview.h"
#include "textdocument.h"
#include "inputcontroller.h"
#include "buildconfig.h"

int main(int argc, char* argv[]) {

	std::string workingDirectory = "./";

	std::string saveFileName;
	std::string loadFileName;

	sf::RenderWindow window(sf::VideoMode(buildconf::winWidth, buildconf::winHeight), buildconf::programName);
	window.setVerticalSyncEnabled(buildconf::VSyncEnabled);
	sf::Color backgroundColor = sf::Color(21, 29, 45);

	TextDocument document;
	
	if (argc == 2) {
		saveFileName = workingDirectory + argv[1];
		loadFileName = workingDirectory + argv[1];
		document.loadFile(loadFileName);
	} else {
		saveFileName = workingDirectory + "swap/new_buffer.txt";
		std::string emptyBuffer = "";
		document.loadBuffer(emptyBuffer);
	}

	EditorContent editorContent(document);

	EditorView editorView(window, workingDirectory, editorContent);
	InputController inputController(editorContent);


	while (window.isOpen()) {
		sf::Event event;
		while (window.pollEvent(event)) {
			if (event.type == sf::Event::Closed) {
				window.close();
			}
			if (event.type == sf::Event::Resized) {
				editorView.setCameraBounds(event.size.width, event.size.height);
			}
			if (event.key.code == sf::Keyboard::S && sf::Keyboard::isKeyPressed(sf::Keyboard::LControl)) {
				if (document.hasChanged()) {
					document.saveFile(saveFileName);
					std::cout << "SAVED TO: " << saveFileName << "\n";
				}
			}

			if (document.hasChanged()) {
				window.setTitle(buildconf::unsavedChangesSymbol + buildconf::programName);
			} else {
				window.setTitle(buildconf::programName);
			}

			inputController.handleEvents(editorView, window, event);
		}

		inputController.handleConstantInput(editorView, window);

		window.clear(backgroundColor);
		window.setView(editorView.getCameraView());
		editorView.draw(window);
		window.display();
	}

	return 0;
}
