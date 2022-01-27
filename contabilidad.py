#!/usr/bin/env python
from clips import Environment, Symbol

environment = Environment()

environment.batch_star('contabilidad.bat')
#environment.load('templates.clp')
# load constructs into the environment
#environment.load('alimentador_rules.clp')

#environment.load('automatico_rules.clp')
#environment.load('carga_rules.clp')
#environment.load('conductor_rules.clp')
#environment.load('empalme_rules.clp')
#environment.load('instalacion_rules.clp')
#environment.load('main_rules.clp')
#environment.load('pdc_rules.clp')
#environment.load('potencia_rules.clp')
#environment.load('reparte_conductor_rules.clp')

# assert a fact as string
#nvironment.assert_string('(a-fact)')

# retrieve a fact template
#emplate = environment.find_template('trafo')

# create a new fact from the template
#act = template.new_fact()

# implied (ordered) facts are accessed as lists
#fact.append(42)
#fact.extend(("foo", "bar"))

# assert the fact within the environment
#act.assertit()

# retrieve another fact template
#template = environment.find_template('another-fact')
#fact = template.new_fact()

# template (unordered) facts are accessed as dictionaries
#fact["slot-name"] = Symbol("foo")

#fact.assertit()

# execute the activations in the agenda
#nvironment.run()

