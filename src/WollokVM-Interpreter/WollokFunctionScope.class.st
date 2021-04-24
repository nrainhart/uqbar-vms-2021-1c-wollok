Class {
	#name : #WollokFunctionScope,
	#superclass : #Object,
	#instVars : [
		'receiver',
		'arguments'
	],
	#category : #'WollokVM-Interpreter'
}

{ #category : #'as yet unclassified' }
WollokFunctionScope class >> newWithReceiver: aReceiver [
	^ self newWithReceiver: aReceiver andArguments: #()
	
]

{ #category : #'as yet unclassified' }
WollokFunctionScope class >> newWithReceiver: aReceiver andArguments: arguments [ 
	^ self new
		receiver: aReceiver;
		arguments: arguments;
		yourself
]

{ #category : #'as yet unclassified' }
WollokFunctionScope >> arguments: someArguments [ 
	arguments := someArguments
]

{ #category : #'as yet unclassified' }
WollokFunctionScope >> assignVariable: variableName withValue: variableValue [
	self flag: #todo."definir si la variable corresponde a una variable local, o a un atributo, o a..."
	receiver assignVariable: variableName withValue: variableValue
]

{ #category : #'as yet unclassified' }
WollokFunctionScope >> declareVariable: variableName withValue: variableValue [ 
	receiver assignVariable: variableName withValue: variableValue.
]

{ #category : #'as yet unclassified' }
WollokFunctionScope >> receiver: aReceiver [ 
	receiver := aReceiver.
]

{ #category : #'as yet unclassified' }
WollokFunctionScope >> variableValue: variableName [
	arguments at: variableName ifPresent: [ :value | ^value ].
	^ receiver variableValue: variableName.
]
