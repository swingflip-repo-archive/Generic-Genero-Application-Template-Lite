Here is where your localisation wording goes. By default GGAT's default language is English. If you are wanting to localise
 your application whilst using GGAT as your application base. Add folders as needed.

Please bare in mind where you are saving your localisation files mind you as it is critical you store the files in
 the correct places.

For Example:

appdir/
|-- main.42m                            --
|-- *.42m                                 |
|-- *.42f                                 |
|-- fglprofile                            |
|   ...                                   |
|-- defaults/*.42s                        |
|-- de/                                   | Program files
|   |-- *.42s                             |
|-- fr/                                   |
|   |-- *.42s                             |
|-- zh/                                   |
|   |-- *.42s                             |
|-- ... other resource files/dirs ...     |
|   ...                                   |
|-- webcomponents                         |
|   |-- component-type                    |
|       |-- component-type.html           |
|       |-- other-web-comp-resource       |
|   ...                                 --

I have written a string extracting tool which is located within the toolbox. This application is an example on how you
can extract strings from your 4gl and per files.

Using the same model, add you localisation according to the manual.

Lastly please add any localisation files and ammend the settings as required in the FGLPROFILE.
(Instructions are available in the Genero Manual)