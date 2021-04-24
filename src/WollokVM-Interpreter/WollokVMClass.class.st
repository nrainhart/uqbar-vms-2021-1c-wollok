Class {
	#name : #WollokVMClass,
	#superclass : #Object,
	#instVars : [
		'name',
		'ast'
	],
	#category : #'WollokVM-Interpreter'
}

{ #category : #'as yet unclassified' }
WollokVMClass >> allDeclarations [
	self flag: #todo."Soportar variables declaradas en superclases"
	^ self classNode variables.
]

{ #category : #accessing }
WollokVMClass >> allVariables [
	self flag: #todo.
	^ #()
]

{ #category : #accessing }
WollokVMClass >> ast [
	^ ast
]

{ #category : #accessing }
WollokVMClass >> ast: anObject [
	ast := anObject
]

{ #category : #'as yet unclassified' }
WollokVMClass >> classNode [
	^ ast elements first.
]

{ #category : #'as yet unclassified' }
WollokVMClass >> methodNamed: aString [ 
	^ self ast elements first methods detect: [:method | method name value = aString] ifNone: nil
]

{ #category : #accessing }
WollokVMClass >> name [
	^ name
]

{ #category : #accessing }
WollokVMClass >> name: anObject [
	name := anObject
]

{ #category : #printing }
WollokVMClass >> printOn: aStream [

	super printOn: aStream.
	
	aStream
		space;
		nextPut: $(;
		print: name;
		nextPut: $)
		 
]

{ #category : #'as yet unclassified' }
WollokVMClass >> superClassName [
	^ast elements first superclass asWollokQualifiedName 
]
