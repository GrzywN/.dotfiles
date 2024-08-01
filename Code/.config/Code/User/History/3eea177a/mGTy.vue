<script setup lang="ts">
import { CalculationForm, initForm } from '@/Pages/Calculation/Partials/config';
import Create from '@/Pages/Calculation/Create.vue';
import { useForm, usePage } from '@inertiajs/vue3';
import CalculationInput from '@/Components/Calculation/CalculationInput.vue';
import CalculationAutoComplete from '@/Components/Calculation/CalculationAutoComplete.vue';
import { PageProps } from '@/types';
import { MaterialResource } from '@/Resources/Material.resource';
import { IsolatorResource } from '@/Resources/Isolator.resource';
import { ref, shallowRef } from 'vue';
import CalculationHorizontalInputSection from '@/Components/Calculation/CalculationHorizontalInputSection.vue';
import CalculationCheckbox from '@/Components/Calculation/CalculationCheckbox.vue';

const { readonly, draftForm } = defineProps<{
    readonly?: boolean;
    draftForm?: CalculationForm;
}>();
const parentComponent = shallowRef(readonly ? 'div' : Create);

const form = draftForm ? useForm(draftForm) : initForm();

const materials = usePage<PageProps<{ materials: Array<MaterialResource> }>>().props.materials;
const isolators = usePage<PageProps<{ isolators: Array<IsolatorResource> }>>().props.isolators;
</script>

<template>
    <component :is="parentComponent" v-model:form="form">
        <div class="debug card">
            <div class="grid">
                <div class="col-12">
                    <div class="text-900 font-medium text-xl mb-3">Ściany</div>
                    <p class="m-0 p-0 text-600 line-height-3 mr-3">Tutaj będą opisy poszczególnych sekcji</p>
                </div>
                <div class="col-12">
                    <CalculationHorizontalInputSection label="Materiał podstawowy ściany" :col="12">
                        <CalculationAutoComplete
                            v-model="form.ebmM"
                            label="Materiał podstawowy ściany"
                            :col="4"
                            :error-message="form.errors.ebmM"
                            :items="materials"
                            :disabled="readonly"
                        />
                        <CalculationInput
                            v-model="form.embD"
                            label="Grubość materiału podstawowego [m]"
                            :col="4"
                            :error-message="form.errors.embD"
                            :disabled="readonly"
                            :readonly="readonly"
                        />
                    </CalculationHorizontalInputSection>

                    <CalculationHorizontalInputSection label="Materiał dodatkowy ściany" :col="12">
                        <CalculationAutoComplete
                            v-model="form.esmM"
                            label="Materiał dodatkowy ściany"
                            :col="4"
                            :error-message="form.errors.esmM"
                            :items="materials"
                            :disabled="readonly"
                        />
                        <CalculationInput
                            v-model="form.esmD"
                            label="Grubość materiału dodatkowego [m]"
                            :col="4"
                            :error-message="form.errors.esmD"
                            :disabled="readonly"
                            :readonly="readonly"
                        />
                    </CalculationHorizontalInputSection>

                    <CalculationHorizontalInputSection label="Czy ma pustkę powietrzną?" :col="12">
                        <CalculationCheckbox
                            class="my-auto"
                            v-model="form.hasAirVoid"
                            label="Czy ściana ma pustkę powietrzną?"
                            :col="4"
                            :readonly="readonly"
                            :disabled="readonly"
                        />
                        <CalculationInput
                            v-model="form.balL"
                            label="Długość balkonów"
                            :col="4"
                            :error-message="form.errors.balL"
                            :disabled="readonly"
                            :readonly="readonly"
                        />
                    </CalculationHorizontalInputSection>

                    <CalculationHorizontalInputSection label="Materiał izolacji ściany" :col="12">
                        <CalculationAutoComplete
                            v-model="form.eimM"
                            label="Materiał izolacji ściany"
                            :col="4"
                            :error-message="form.errors.ebmM"
                            :items="materials"
                            :disabled="readonly"
                        />
                        <CalculationInput
                            v-model="form.eimD"
                            label="Grubość materiału izolacji [m]"
                            :col="4"
                            :error-message="form.errors.eimD"
                            :disabled="readonly"
                            :readonly="readonly"
                        />
                    </CalculationHorizontalInputSection>
                </div>
            </div>
        </div>
    </component>
</template>
