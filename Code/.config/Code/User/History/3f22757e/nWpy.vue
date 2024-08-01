<script setup lang="ts">
import { CalculationForm, initForm } from '@/Pages/Calculation/Partials/config';
import Create from '@/Pages/Calculation/Create.vue';
import CalculationInput from '@/Components/Calculation/CalculationInput.vue';
import CalculationAutoComplete from '@/Components/Calculation/CalculationAutoComplete.vue';
import { useForm, usePage } from '@inertiajs/vue3';
import { PageProps } from '@/types';
import { MaterialResource } from '@/Resources/Material.resource';
import { IsolatorResource } from '@/Resources/Isolator.resource';
import { ref, shallowRef } from 'vue';
import CalculationCheckbox from '@/Components/Calculation/CalculationCheckbox.vue';
import CalculationHorizontalInputSection from '@/Components/Calculation/CalculationHorizontalInputSection.vue';

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
        <div class="card">
            <div class="grid">
                <div class="col-12 lg:col-2">
                    <div class="text-900 font-medium text-xl mb-3">Piwnica</div>
                </div>

                <div class="col-12">
                    <Fieldset>
                        <template #legend>
                            <div class="flex align-items-center pl-2">
                                <span class="font-bold">Izolacja dachu</span>
                            </div>
                        </template>

                        <CalculationHorizontalInputSection label="Czy piwnica jest ogrzewana?" :col="12">
                            <CalculationCheckbox
                                v-model="form.isBasementHeated"
                                label="Czy piwnica jest ogrzewana?"
                                :col="6"
                                :readonly="readonly"
                                :disabled="readonly"
                            />
                        </CalculationHorizontalInputSection>

                        <CalculationHorizontalInputSection label="Materiał stropu nad piwnicą" :col="12">
                            <CalculationAutoComplete
                                v-model="form.bsbmM"
                                label="Materiał stropu nad piwnicą"
                                :col="3"
                                :error-message="form.errors.bsbmM"
                                :items="materials"
                                :disabled="readonly"
                            />
                            <!-- TODO: zmienić na cm -->
                            <CalculationInput
                                v-model="form.bsbmD"
                                label="Grubość stropu nad piwnicą [m]"
                                :col="3"
                                :error-message="form.errors.bsbmD"
                                :disabled="readonly"
                                :readonly="readonly"
                            />
                        </CalculationHorizontalInputSection>

                        <CalculationHorizontalInputSection label="Docieplenie stropu nad piwnicą" :col="12">
                            <CalculationAutoComplete
                                v-model="form.bsimM"
                                label="Docieplenie stropu nad piwnicą"
                                :col="3"
                                :error-message="form.errors.bsimM"
                                :items="isolators"
                                :disabled="readonly"
                            />
                            <CalculationInput
                                v-model="form.bsimD"
                                label="Grubość docieplenia stropu [m]"
                                :col="3"
                                :error-message="form.errors.bsimD"
                                :disabled="readonly"
                                :readonly="readonly"
                            />
                        </CalculationHorizontalInputSection>
                    </Fieldset>
                </div>
                <div v-if="form.isBasementHeated" class="col-12">
                    <Fieldset>
                        <template #legend>
                            <div class="flex align-items-center pl-2">
                                <span class="font-bold">Ogrzewana piwnica</span>
                            </div>
                        </template>
                        <CalculationHorizontalInputSection label="Materiał ścian piwnicy" :col="12">
                            <CalculationAutoComplete
                                v-model="form.ebbmM"
                                label="Materiał ścian zewnętrznych piwnicy"
                                :col="3"
                                :error-message="form.errors.ebbmM"
                                :items="materials"
                                :disabled="readonly"
                            />
                            <CalculationInput
                                v-model="form.ebbmD"
                                label="Grubość ścian zewnętrznych piwnicy"
                                :col="3"
                                :error-message="form.errors.ebbmD"
                                :disabled="readonly"
                                :readonly="readonly"
                            />
                        </CalculationHorizontalInputSection>

                        <CalculationHorizontalInputSection label="Docieplenie ścian piwnicy" :col="12">
                            <CalculationAutoComplete
                                v-model="form.ebimM"
                                label="Docieplenie ścian zewnętrznych piwnicy"
                                :col="3"
                                :error-message="form.errors.ebimM"
                                :items="isolators"
                                :disabled="readonly"
                                :readonly="readonly"
                            />
                            <CalculationInput
                                v-model="form.ebimD"
                                label="Grubość docieplenia ścian zewnętrznych piwnicy"
                                :col="3"
                                :error-message="form.errors.ebimD"
                                :disabled="readonly"
                                :readonly="readonly"
                            />
                        </CalculationHorizontalInputSection>

                        <CalculationHorizontalInputSection label="Poziom poniżej gruntu" :col="12">
                            <CalculationInput
                                v-model="form.fhb"
                                label="Wysokość piwnicy (+30cm)"
                                :col="3"
                                :error-message="form.errors.fhb"
                                :disabled="readonly"
                                :readonly="readonly"
                            />
                            <CalculationInput
                                v-model="form.z"
                                label="Głębokość poniżej gruntu"
                                :col="3"
                                :error-message="form.errors.z"
                                :disabled="readonly"
                                :readonly="readonly"
                            />
                        </CalculationHorizontalInputSection>
                    </Fieldset>
                </div>

                <div class="col-12">
                    <div class="grid formgrid p-fluid align-items-start">
                        <!--                        <CalculationAutoComplete-->
                        <!--                            v-model="form.gsimM"-->
                        <!--                            label="Materiał podłogi piwnicy"-->
                        <!--                            :col="3"-->
                        <!--                            :error-message="form.errors.gsimM"-->
                        <!--                            :items="materials"-->
                        <!--                        />-->
                        <!--                        <CalculationInput-->
                        <!--                            v-model="form.gsimD"-->
                        <!--                            label="Grubość podłogi piwnicy [m]"-->
                        <!--                            :col="3"-->
                        <!--                            :error-message="form.errors.gsimD"-->
                        <!--                        />-->
                    </div>
                    <div class="grid formgrid p-fluid align-items-start"></div>

                    <Fieldset>
                        <template #legend>
                            <div class="flex align-items-center pl-2">
                                <span class="font-bold">Materiał Podstawowy</span>
                            </div>
                        </template>

                        <div class="grid formgrid p-fluid align-items-start">
                            <CalculationAutoComplete
                                v-model="form.gsimM2"
                                label="Materiał podłogi piwnicy"
                                :col="6"
                                :error-message="form.errors.gsimM2"
                                :items="materials"
                                :disabled="readonly"
                            />
                            <CalculationInput
                                v-model="form.gsimD2"
                                label="Grubość podłogi piwnicy [m]"
                                :col="6"
                                :error-message="form.errors.gsimD2"
                                :disabled="readonly"
                                :readonly="readonly"
                            />
                        </div>
                    </Fieldset>

                    <Fieldset class="mt-5">
                        <template #legend>
                            <div class="flex align-items-center pl-2">
                                <span class="font-bold">Materiał izolacyjny</span>
                            </div>
                        </template>

                        <div class="grid formgrid p-fluid align-items-start">
                            <CalculationAutoComplete
                                v-model="form.gsbmM2"
                                label="Materiał izolacyjny podłogi piwnicy"
                                :col="6"
                                :error-message="form.errors.gsbmM2"
                                :items="materials"
                                :disabled="readonly"
                                :readonly="readonly"
                            />
                            <CalculationInput
                                v-model="form.gsbmD2"
                                label="Grubość izolacyjny podłogi piwnicy [m]"
                                :col="6"
                                :error-message="form.errors.gsbmD2"
                                :disabled="readonly"
                                :readonly="readonly"
                            />
                        </div>
                    </Fieldset>
                </div>
            </div>
        </div>
    </component>
</template>
