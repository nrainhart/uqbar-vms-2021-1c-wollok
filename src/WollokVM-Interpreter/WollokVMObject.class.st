Class {
	#name : #WollokVMObject,
	#superclass : #Object,
	#instVars : [
		'wollokClass',
		'instanceVariables'
	],
	#category : #'WollokVM-Interpreter'
}

{ #category : #'as yet unclassified' }
WollokVMObject >> assignVariable: aVariableName withValue: aVariableValue [
	self flag: #todo.
	instanceVariables at: aVariableName put: aVariableValue 
]

{ #category : #UI }
WollokVMObject >> gtInspectorVariablesIn: composite [
	<gtInspectorPresentationOrder: 1> 

	^ composite fastTable
		title: 'Wollok Inspector';
		display: [ self valueCollection ];
		column: 'Name' evaluated: [ :each | GTObjectPrinter asTruncatedTextFrom: each key ];
		column: 'Value' evaluated: [ :each | GTObjectPrinter asTruncatedTextFrom: each value ];
		send: [ :selection | 
			selection
				ifNil: [ nil ]
				ifNotNil: [ selection value ] ]
]

{ #category : #accessing }
WollokVMObject >> initialize [

	instanceVariables := Dictionary new. 
]

{ #category : #'as yet unclassified' }
WollokVMObject >> instanceVariables: instanceVariableValues [ 
	^ instanceVariables := instanceVariableValues
]

{ #category : #accessing }
WollokVMObject >> instanceVariablesValues [

	^ instanceVariables 
]

{ #category : #printing }
WollokVMObject >> printOn: aStream [

	super printOn: aStream.
	
	aStream
		space;
		nextPut: $(;
		print: wollokClass;
		nextPut: $)

		 
]

{ #category : #accessing }
WollokVMObject >> valueCollection [

	^ { 'self' -> self }, 
			(self wollokClass allVariables
				with: self instanceVariablesValues
				collect: [ :n :v | n key variable name value -> v ])
]

{ #category : #'as yet unclassified' }
WollokVMObject >> variableValue: aString [ 
	^ self instanceVariablesValues at: aString ifAbsent: nil
]

{ #category : #accessing }
WollokVMObject >> wollokClass [
	^ wollokClass
]

{ #category : #accessing }
WollokVMObject >> wollokClass: anObject [
	wollokClass := anObject
]

{ #category : #accessing }
WollokVMObject >> wollokClassName [
	
	^ wollokClass name
]
